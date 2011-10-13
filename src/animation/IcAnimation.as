package animation {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class IcAnimation {
		private var _name:String;
		private var _movieClip:MovieClip;
		
		public function IcAnimation(name:String, movieClip:MovieClip):void {
			_name = name;
			_movieClip = movieClip;
		}
		
		public function get name():String { return _name; }
		public function get movieClip():MovieClip { return _movieClip; }
		
		/* Internal functions */
		
	}
}
