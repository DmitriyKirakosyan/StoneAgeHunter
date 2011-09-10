package tilemap
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class Tile extends Sprite {
		private var _textureVO:TextureVO;
		
		private var canvas:Bitmap;
		
		private var _glow:Boolean;
		
		private const LIGHT_FILTER:ColorMatrixFilter = new ColorMatrixFilter([
			1.3, 0, 0, 0, 0,
			0, 1.3, 0, 0, 0,
			0, 0, 1.3, 0, 0,
			0, 0, 0, 1, 0]);
		
		public function Tile(textureVO:TextureVO)
		{
			super();
			_textureVO = textureVO;
			init();
		}
		
		public function remove():void{
			removeEventListener(MouseEvent.ROLL_OUT, dontGlow);
			removeEventListener(MouseEvent.ROLL_OVER, glow);
		}
		
		private function init():void{
			var spritesheet:BitmapData = _textureVO.textureBitmap;
			var tempBtm:BitmapData = new BitmapData(spritesheet.width, spritesheet.height);
			tempBtm.copyPixels(spritesheet, new Rectangle(0, 0, spritesheet.width, spritesheet.height),
																										new Point(0,0));
			canvas = new Bitmap(tempBtm);
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