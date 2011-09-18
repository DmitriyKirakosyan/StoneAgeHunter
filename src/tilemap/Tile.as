package tilemap {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	public class Tile extends Sprite {
		private var _textureUrl:String;
		private var _tileName:String;
		
		private var canvas:Bitmap;
		
		public function Tile(tileName:String, textureUrl:String) {
			super();
			_tileName = tileName;
			_textureUrl = textureUrl;
			init();
		}
		
		private function init():void{
			var tileBitmapData:BitmapData = SharedBitmapHolder.instance.getTileByName(_textureUrl, _tileName);
			canvas = new Bitmap(tileBitmapData);
			addChild(canvas);
		}
		
	}
}