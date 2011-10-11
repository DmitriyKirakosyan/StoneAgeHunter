package tilemap {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	public class Tile extends Sprite {
		
		public function Tile() {
			super();
			init();
		}
		
		private function init():void{
			addChild(new GroundM());
		}
		
	}
}