package tilemap {
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	
	public class SharedBitmapHolder extends EventDispatcher {
		
		public static var urlPrefix:String = "";
		
		private static const THREADS:uint = 3;
		private const CACHE:Dictionary = new Dictionary();
		private static const LOADER_CONTEXT:LoaderContext = new LoaderContext(true);
		
		private static var _instance:SharedBitmapHolder;
		
		private const loaders:Vector.<Loader> = new Vector.<Loader>();
		private const urlLoaders:Vector.<URLLoader> = new Vector.<URLLoader>();
		private const queues:Vector.<QueueItem> = new Vector.<QueueItem>();
		private const currentQueues:Vector.<QueueItem> = new Vector.<QueueItem>();
		
		public static function get instance():SharedBitmapHolder {
			if (_instance == null) {
				_instance = new SharedBitmapHolder();
			}
			return _instance;
		}
		
		public static function load(url:String):void {
			const q:QueueItem = new QueueItem();
			q.url = url;
			instance.load(q);
		}
		
		public static function cretaeTileById(tileId:String):void {
			
		}
		
		public static function existInCache(url:String):Boolean {
			return instance.CACHE[url] != undefined;
		}
		
		public static function existInQueue(url:String):Boolean {
			var q:QueueItem;
			for each (q in instance.currentQueues) {
				if (q.url == url) return true;
			}
			for each (q in instance.queues) {
				if (q.url == url) return true;
			}
			return false;
		}
		
		private function getValueByKey(key:String, xml:XML):Number{
			const integerList:XMLList = xml.child("integer");
			const realList:XMLList = xml.child("real");
			const keyList:XMLList = xml.child("key");

			for (var i:int = 0; i < keyList.length(); i++){
				if(keyList[i] == key){
					if (key == "offsetX" || key == "offsetY") {
						return realList[i - integerList.length() + 2];
					} else if (key == "originalWidth" || key == "originalHeight") {
						return integerList[i - 2];
					}
					return integerList[i]; 
				}
			}
			return 0;
		}
		
		private function getTileRectangle(xml:XML):Rectangle{
			return new Rectangle(getValueByKey("x", xml),
								 getValueByKey("y", xml),
								 getValueByKey("width", xml),
								 getValueByKey("height", xml));
		}
		
		private function getTileDataByName(texture:String, name:String):XML{
			var xml:XML = CACHE[texture]["textureXML"];
			for(var i:int = 0; i<xml.dict.dict[1].key.length(); i++){
				if(xml.dict.dict[1].key[i] == name){
					return xml.dict.dict[1].dict[i];
				}
			}
			return null;
		}
		
		public function getTileByName(textureUrl:String, name:String):BitmapData {
			const tileXML:XML = getTileDataByName(textureUrl, name);
			const rect:Rectangle = getTileRectangle(tileXML);
			const xOffset:Number = getValueByKey("offsetX", tileXML);
			const yOffset:Number = getValueByKey("offsetY", tileXML);
			const originalWidth:int = getValueByKey("originalWidth", tileXML);
			const originalHeight:int = getValueByKey("originalHeight", tileXML);
			trace("xOffset : " + xOffset + ", yOffset : " + yOffset);
			const texture:TextureVO = CACHE[textureUrl];
			const result:BitmapData = new BitmapData(originalWidth, originalHeight, true, 0);
			result.copyPixels(texture.textureBitmap, rect, new Point(-xOffset, -yOffset));
			return result;
		}
		
		public static function getTextureByURL(url:String):TextureVO {
			return instance.CACHE[url] as TextureVO;
		}
		
		public function clearCache():void {
			for each (var q:QueueItem in instance.currentQueues) {
				if (q.loader) {
					try {
						q.loader.close();
						q.urlLoader.close();
					} catch(error:Error) {}
					instance.loaders.push(q.loader);
					instance.urlLoaders.push(q.urlLoader);
					q.loader = null;
					q.urlLoader = null;
				}
			}
			
			instance.currentQueues.splice(0, instance.currentQueues.length);
			instance.queues.splice(0, instance.queues.length);
			
			var bmd:BitmapData;
			for (var str:String in CACHE) {
				if (CACHE[str] && CACHE[str] is BitmapData) {
					bmd = CACHE[str] as BitmapData;
					bmd.dispose();
					bmd = null;
					CACHE[str] = undefined;
				}
			}
		}
		
		public function SharedBitmapHolder() {
			init();
		}
		
		private function init():void {
			var l:Loader;
			var urlL:URLLoader;
			for (var i:int = 0; i < THREADS; ++i) {
				l = new Loader();
				l.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);
				l.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
				loaders.push(l);
				urlL = new URLLoader();
				urlL.addEventListener(Event.COMPLETE, onURLLoaderComplete);
				urlL.addEventListener(IOErrorEvent.IO_ERROR, onURLError);
				urlLoaders.push(urlL);
			}
		}
		
		// LOADER EVENTS
		private function onLoaderComplete(event:Event):void {
			const li:LoaderInfo = event.target as LoaderInfo;
			if (li.content == null || !(li.content is Bitmap)) {
			} else {
				const queueItem:QueueItem = getQueueItemByLoader(li.loader);
				if (!queueItem) { return; }
				if (queueItem.numCompletes > 0) {
					saveToCache(queueItem);
				} else{
					queueItem.numCompletes++;
				}
			}
		}
		
		private function onURLLoaderComplete(event:Event):void {
			const urll:URLLoader = event.target as URLLoader;
			if (urll.data == null) {
			} else {
				const queueItem:QueueItem = getQueueItemByURLLoader(urll);
				if (!queueItem) { return; }
				if (queueItem.numCompletes > 0) {
					saveToCache(queueItem);
				} else {
					queueItem.numCompletes++;
				}
			}
		}
		
		private function onError(event:IOErrorEvent):void {
			trace("loaderError");
		}
		
		private function onURLError(event:IOErrorEvent):void {
			trace("URLLoaderError");
		}
		
		private function saveToCache(queueItem:QueueItem):void{
			const bmd:BitmapData = (queueItem.loader.content as Bitmap).bitmapData;
			const textureVo:TextureVO = new TextureVO();
			textureVo.textureBitmap = bmd;
			const xml:XML = new XML(queueItem.urlLoader.data);
			textureVo.textureXML = xml;
			CACHE[queueItem.url] = textureVo;
			loaders.push(queueItem.loader);
			urlLoaders.push(queueItem.urlLoader);
			currentQueues.splice(currentQueues.indexOf(queueItem), 1);
			dispatchEvent(new TextureHolderEvent(TextureHolderEvent.TEXTURE_LOADED, queueItem.url));
			loadNext();
		}
		
		// LOAD NEXT
		private function loadNext():void {
			if (queues.length == 0 || loaders.length == 0) return;
			const queueItem:QueueItem = queues.shift();
			if (!existInCache(queueItem.url) && !getQueueItemByURL(queueItem.url)) {
				currentQueues.push(queueItem);
				const l:Loader = loaders.shift();
				const ul:URLLoader = urlLoaders.shift();
				queueItem.loader = l;
				queueItem.urlLoader = ul;
				l.load(new URLRequest(urlPrefix + queueItem.url + ".png"), LOADER_CONTEXT);
				ul.load(new URLRequest(urlPrefix + queueItem.url + ".plist"));
			}
			
			if (loaders.length > 0) loadNext();
			
		}
		
		// LOAD
		private function load(queueItem:QueueItem):void {
			queues.push(queueItem);
			if (queues.length == 1) loadNext();
		}
		
		private function getQueueItemByURL(url:String):QueueItem {
			for each (var q:QueueItem in currentQueues) {
				if (q.url == url) return q;
			}
			return null;
		}
		
		private function getQueueItemByURLLoader(l:URLLoader):QueueItem {
			for each (var q:QueueItem in currentQueues) {
				if (q.urlLoader == l) return q;
			}
			return null;
		}
		
		private function getQueueItemByLoader(l:Loader):QueueItem {
			for each (var q:QueueItem in currentQueues) {
				if (q.loader == l) return q;
			}
			return null;
		}
		
	}
	
}

import flash.display.Loader;
import flash.net.URLLoader;

class QueueItem {
	
	public var url:String;
	public var numCompletes:uint = 0;
	public var loader:Loader;
	public var urlLoader:URLLoader;
	
}