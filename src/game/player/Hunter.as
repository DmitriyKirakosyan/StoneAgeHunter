package game.player {
	import animation.IcSprite;
	import tilemap.TextureHolderEvent;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import tilemap.SharedBitmapHolder;
	import com.greensock.easing.Linear;
	import com.greensock.TimelineMax;
	import flash.geom.Point;
	import com.greensock.TweenLite;
	import flash.display.Sprite;

	public class Hunter extends IcSprite {
		private var _view:Sprite;
		private const textureUrl:String = "animations/walk/walk";
		
		private var _path:Vector.<Point>;
		private var _pathTimeline:TimelineMax;
		private var _moving:Boolean;
		
		public function Hunter() {
			super();
			_moving = false;
			addImage();
		}
		
		/* API */
		
		public function get path():Vector.<Point> {
			return _path;
		}
		
		public function remove():void {
			removeChild(_view);
			_view = null;
		}
		
		public function addWayPoint(point:Point):void {
			if (!_path) { _path = new Vector.<Point>(); }
			if (_path.indexOf(point) == -1) {
				_path.push(point);
				addPointToTimeline(point);
			}
		}
		
		public function move():void {
			if (_pathTimeline) { _pathTimeline.play(); }
		}
		
		public function pauseMove():void {
			if (_pathTimeline) { _pathTimeline.pause(); }
		}
/*		
		public function followPath(path:Vector.<Point>):void {
			if (!path || path.length == 0) { return; }
			_moving = true;
			_pathTimeline = new TimelineMax();
			for each (var point:Point in path) {
				_pathTimeline.append(new TweenLite(this, .9, {x : point.x-this.width/2, y : point.y-this.height/2,
																						ease : Linear.easeNone,
																						onStart : onStartPoint}));
			}
		}
		 * 
		 */
		
		/* Internal functions */
		
		private function addPointToTimeline(point:Point):void {
			if (!_pathTimeline) {
				_pathTimeline = new TimelineMax();
				_pathTimeline.pause();
			}
			_pathTimeline.append(new TweenLite(this, .9, {x : point.x - this.width/2, y : point.y - this.height/2,
																										ease : Linear.easeNone,
																										onStart : onStartPoint,
																										onStartParams : [point]}));
		}
		
		private function onStartPoint(point:Point):void {
			if (_path && _path.length > 0) {
				removePreviousePoint(point);
			} else {
				trace("[Hunter.onStartPoint] somthing wrong");
			}
		}
		
		private function removePreviousePoint(point:Point):void {
			const index:int = _path.indexOf(point);
			var iter:int = index-1;
			if (index != -1) {
				while (iter >= 0) { _path.shift(); iter--; }
			}
		}
		
		private function addImage():void {
			_view = new Sprite;
			if (SharedBitmapHolder.existInCache(textureUrl)) {
				const bitmap:BitmapData = SharedBitmapHolder.instance.getTileByName(textureUrl, "CaveMan0001.png");
				_view.addChild(new Bitmap(bitmap));
			} else {
				SharedBitmapHolder.instance.addEventListener(TextureHolderEvent.TEXTURE_LOADED, onImgLoaded);
			}
			addChild(_view);
		}
		
		private function onImgLoaded(event:TextureHolderEvent):void {
			if (event.url != textureUrl) { return; }
				const bitmap:BitmapData = SharedBitmapHolder.instance.getTileByName(textureUrl, "CaveMan0001.png");
				_view.addChild(new Bitmap(bitmap));
		}
	}
}
