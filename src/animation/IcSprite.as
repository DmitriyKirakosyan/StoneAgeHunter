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
		private var _isBackAnimation:Boolean; //this is question need this or not
		
		public function IcSprite() {
			super();
			_animating = false;
		}
		
		/* API */
		
		public function get isBackAnimation():Boolean { return _isBackAnimation; }
		
		/**
		 * override this if need
		 */
		public function getAlternativeCopy(copyName:String = ""):IcSprite {
			return copyName == "" ? this : null;
		}
		
		public function addAnimation(name:String, movieClip:MovieClip, movieClipBack:MovieClip = null):void {
			if (!_animations) { _animations = new Vector.<IcAnimation>(); }
			_animations.push(new IcAnimation(name, movieClip, movieClipBack));
		}
		
		public function play(animationName:String = "", back:Boolean = false):void {
			if (animationName != "") {
				const icAnimation:IcAnimation = getAnimationByName(animationName);
				if (icAnimation) { playAnimation(icAnimation, back); }
			} else {
				if (_animations && _animations.length > 0) {
					playAnimation(_animations[0], back);
				}
			}
		}
		
		protected function changeToBackAnimation():void {
			if (!_isBackAnimation) {
				playAnimation(_currentAnimation, true);
			}
		}
		
		protected function changeToFrontAnimation():void {
			if (_isBackAnimation) {
				playAnimation(_currentAnimation, false);
			}
		}
		
		/* Internal functions */
		
		private function playAnimation(icAnimation:IcAnimation, backAnimation:Boolean):void {
			if (_currentAnimation) {
				var currentAnimationMC:MovieClip = getBackOrFrontAnimation(icAnimation, _isBackAnimation);
				if (this.contains(currentAnimationMC)) { this.removeChild(currentAnimationMC); }
			}
			_currentAnimation = icAnimation;
			this.addChild(getBackOrFrontAnimation(icAnimation, backAnimation));
			_animating = true;
			_isBackAnimation = backAnimation;
		}
		
		private function getBackOrFrontAnimation(icAnimation:IcAnimation, back:Boolean):MovieClip {
			return back ? icAnimation.backAnimation : icAnimation.animation;
		}
		
		private function getAnimationByName(name:String):IcAnimation {
			for each (var icAnimation:IcAnimation in _animations) {
				if (icAnimation.name == name) { return icAnimation; }
			}
			return null;
		}
		
	}
}
