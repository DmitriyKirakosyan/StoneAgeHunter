package game.map.tilemap {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	
	public class Tile extends Sprite {
		private var _tileName:int;
		
		public static const FREE:int = 0;
		public static const LOCK:int = 1;
		
		public function Tile(tileName:int) {
			super();
			_tileName = tileName;
			if (tileName == LOCK) { filters = [new BlurFilter()]; }
			init();
		}
		
		public function get locked():Boolean { return _tileName == LOCK; }
		
		private function init():void{
			addChild(new GroundM());
		}
		
	}
}