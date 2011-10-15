package animation {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;

	public class IcSprite extends Sprite {
		private var _animations:Vector.<IcAnimation>;
		private var _animating:Boolean;
		private var _currentAnimation:IcAnimation;
		
		public function IcSprite() {
			super();
			_animating = false;
		}
		
		/* API */
		
		/**
		 * override this if need
		 */
		public function getAlternativeCopy(copyName:String = ""):IcSprite {
			return copyName == "" ? this : null;
		}
		
		public function addAnimation(name:String, movieClip:MovieClip):void {
			if (!_animations) { _animations = new Vector.<IcAnimation>(); }
			_animations.push(new IcAnimation(name, movieClip));
		}
		
		public function play(animationName:String = ""):void {
			if (animationName != "") {
				const icAnimation:IcAnimation = getAnimationByName(animationName);
				if (icAnimation) { playAnimation(icAnimation); }
			} else {
				if (_animations && _animations.length > 0) {
					playAnimation(_animations[0]);
				}
			}
		}
		
		/* Internal functions */
		
		private function playAnimation(icAnimation:IcAnimation):void {
			if (_currentAnimation) {
				if (this.contains(_currentAnimation.animation)) { this.removeChild(_currentAnimation.animation); }
			}
			_currentAnimation = icAnimation;
			this.addChild(icAnimation.animation);
			_animating = true;
		}
		
		private function getAnimationByName(name:String):IcAnimation {
			for each (var icAnimation:IcAnimation in _animations) {
				if (icAnimation.name == name) { return icAnimation; }
			}
			return null;
		}
		
	}
}
