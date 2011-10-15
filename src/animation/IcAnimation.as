package animation {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class IcAnimation {
		private var _name:String;
		private var _animation:MovieClip;
		private var _animationBack:MovieClip;
		
		public function IcAnimation(name:String, movieClip:MovieClip, movieClipBack:MovieClip = null):void {
			_name = name;
			_animation = movieClip;
			_animationBack = movieClipBack;
		}
		
		public function get name():String { return _name; }
		public function get animation():MovieClip { return _animation; }
		public function get backAnimation():MovieClip { return _animationBack; }
		
		/* Internal functions */
		
	}
}
