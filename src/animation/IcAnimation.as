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
		private var _priority:uint;
		private var _playOnce:Boolean;

		public static const PRIORITY_LOW:uint = 0;
		public static const PRIORITY_MEDIUM:uint = 1;
		public static const PRIORITY_HIGH:uint = 2;
		
		public function IcAnimation(name:String, movieClip:MovieClip, movieClipBack:MovieClip = null, priority:uint = PRIORITY_LOW,  playOnce:Boolean = false):void {
			_name = name;
			_animation = movieClip;
			_animationBack = movieClipBack;
			_priority = priority;
			_playOnce = playOnce;
		}
		
		public function get name():String { return _name; }
		public function get animation():MovieClip { return _animation; }
		public function get backAnimation():MovieClip { return _animationBack; }
		public function get priority():uint { return _priority; }
		public function get playOnce():Boolean { return _playOnce; }
		
		/* Internal functions */
		
	}
}
