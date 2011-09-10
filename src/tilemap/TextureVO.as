package tilemap
{
	import flash.display.BitmapData;

	public class TextureVO
	{
		
		private var _textureBitmap:BitmapData;
		private var _textureXML:XML;
		
		public function TextureVO()
		{
		}
		
		public function get textureBitmap():BitmapData{
			return _textureBitmap;
		}
		
		public function set textureBitmap(value:BitmapData):void{
			_textureBitmap = value;
		}
		
		public function get textureXML():XML{
			return _textureXML;
		}
		
		public function set textureXML(value:XML):void{
			_textureXML = value;
		}
	}
}