package tilemap {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	
	public class Tile extends Sprite {
		private var _textureUrl:String;
		private var _tileName:String;
		
		private var canvas:Bitmap;
		
		private var _glow:Boolean;
		
		private const LIGHT_FILTER:ColorMatrixFilter = new ColorMatrixFilter([
			1.3, 0, 0, 0, 0,
			0, 1.3, 0, 0, 0,
			0, 0, 1.3, 0, 0,
			0, 0, 0, 1, 0]);
		
		public function Tile(tileName:String, textureUrl:String) {
			super();
			_tileName = tileName;
			_textureUrl = textureUrl;
			init();
		}
		
		public function remove():void{
			removeEventListener(MouseEvent.ROLL_OUT, dontGlow);
			removeEventListener(MouseEvent.ROLL_OVER, glow);
		}
		
		private function init():void{
			var tileBitmapData:BitmapData = SharedBitmapHolder.instance.getTileByName(_textureUrl, _tileName);
			canvas = new Bitmap(tileBitmapData);
			addChild(canvas);
			addEventListener(MouseEvent.ROLL_OUT, dontGlow);
			addEventListener(MouseEvent.ROLL_OVER, glow);
		}
		
		private function dontGlow(event:MouseEvent):void{
			_glow = false;
			updateFilters();
		}
		
		private function glow(event:MouseEvent):void{
			_glow = true;
			updateFilters();
		}
		
		private function updateFilters():void {
			const filters:Array = [];
			if (_glow){ filters.push(LIGHT_FILTER); };
			canvas.filters = filters;
		}
	}
}