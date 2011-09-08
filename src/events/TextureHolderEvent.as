package events {
	
	import flash.events.Event;
	
	public class TextureHolderEvent extends Event {
		
		public static const TEXTURE_LOADED:String = "textureLoaded";
		
		private var _url:String;
		
		public function TextureHolderEvent(type:String, url:String) {
			_url = url;
			super(type);
		}
		
		public function get url():String { return _url }
		
	}
	
}