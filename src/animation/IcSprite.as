package animation {
	import event.IcSpriteEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;

	public class IcSprite extends Sprite {
		private var _animationContainer:Sprite;
		private var _animations:Vector.<IcAnimation>;
		private var _animating:Boolean;
		private var _currentAnimation:IcAnimation;
		
		private var _underAll:Boolean;
		
		protected var parallaxForce:Number = 0.0004;
		
		
		//2 составляющи позиции по оси X (действительное положение и параллакс отступ)
		protected var _realXpos:int;
		protected var _parallaxOffset:int;
		
		private var _isBackAnimation:Boolean; //this is question need this or not
		
		public function IcSprite() {
			super();
			_animating = false;
			_animationContainer = new Sprite();
			this.addChild(_animationContainer);
		}
		
		/* API */

		public function set underAll(value:Boolean):void { _underAll = value; }

		public function get realXpos():int
		{
			return _realXpos;
		}

		public function set realXpos(value:int):void
		{
			_realXpos = value;
			updatePosition();
		}
		
		override public function set y(value:Number):void
		{
			// TODO Auto Generated method stub
			super.y = value;
			dispatchEvent(new IcSpriteEvent(IcSpriteEvent.MOVE_BY_Y, this));
		}
		
		
		public function get parallaxOffset():int
		{
			return _parallaxOffset;
		}

		public function set parallaxOffset(value:int):void
		{
			_parallaxOffset = value;
			_parallaxOffset *= parallaxForce * y;
			updatePosition();
		}
		
		private function updatePosition():void
		{
			x = _realXpos + _parallaxOffset;
		}
		
		public function get isBackAnimation():Boolean { return _isBackAnimation; }
		
		public function set animationScale(value:Number):void {
			_animationContainer.scaleX = value;
			_animationContainer.scaleY = value;
		}
		
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
				if (icAnimation && _currentAnimation != icAnimation) { playAnimation(icAnimation, back); }
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
				var currentAnimationMC:MovieClip = getBackOrFrontAnimation(_currentAnimation, _isBackAnimation);
				if (_animationContainer.contains(currentAnimationMC)) { _animationContainer.removeChild(currentAnimationMC); }
			}
			_currentAnimation = icAnimation;
			_animationContainer.addChild(getBackOrFrontAnimation(icAnimation, backAnimation));
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
