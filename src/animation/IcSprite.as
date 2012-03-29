package animation {
	import events.IcSpriteEvent;
	
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
		private var _nextAnimationName:String;

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

		public function get realXpos():int { return _realXpos; }
		public function set realXpos(value:int):void {
			_realXpos = value;
			updatePosition();
		}
		private function updatePosition():void {
			x = _realXpos + _parallaxOffset;
		}


		override public function set y(value:Number):void {
			super.y = value;
			dispatchEvent(new IcSpriteEvent(IcSpriteEvent.MOVE_BY_Y, this));
		}
		
		
		public function get parallaxOffset():int {
			return _parallaxOffset;
		}

		public function set parallaxOffset(value:int):void {
			_parallaxOffset = value;
			_parallaxOffset *= parallaxForce * y;
			updatePosition();
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
		
		public function addAnimation(icAniamtion:IcAnimation):void {
			if (!_animations) { _animations = new Vector.<IcAnimation>(); }
			if (icAniamtion) {
				_animations.push(icAniamtion);
			}
		}
		
		public function play(animationName:String = "", back:Boolean = false):void {
			if (animationName != "") {
				const icAnimation:IcAnimation = getAnimationByName(animationName);
				if (icAnimation && _currentAnimation != icAnimation) {
					if (icAnimation.playOnce) {
						_nextAnimationName = _currentAnimation.name;
					}
					playAnimation(icAnimation, back);
				}
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
			if (_currentAnimation && _currentAnimation.priority > icAnimation.priority) {
				_nextAnimationName = icAnimation.name;
				return;
			}
			if (_currentAnimation == icAnimation && _currentAnimation.playOnce) {
				return;
			}
			removeCurrentAnimation();
			_currentAnimation = icAnimation;
			var movieClipAnimation:MovieClip = getBackOrFrontAnimation(icAnimation, backAnimation);
			movieClipAnimation.gotoAndPlay(1);
			_animationContainer.addChild(movieClipAnimation);
			_animating = true;
			_isBackAnimation = backAnimation;
			if (icAnimation.playOnce) {
				movieClipAnimation.addEventListener(Event.ENTER_FRAME, onAnimationEnterFrame);
			}
		}

		private function removeCurrentAnimation():void {
			if (_currentAnimation) {
				var currentAnimationMC:MovieClip = getBackOrFrontAnimation(_currentAnimation, _isBackAnimation);
				if (_currentAnimation.playOnce) {
					currentAnimationMC.removeEventListener(Event.ENTER_FRAME, onAnimationEnterFrame);
				}
				_currentAnimation.stop();
				if (_animationContainer.contains(currentAnimationMC)) { _animationContainer.removeChild(currentAnimationMC); }
				_currentAnimation = null;
			}
		}

		private function onAnimationEnterFrame(event:Event):void {
			if (!_currentAnimation) { trace("current animation dont exists [IcSprite.onAnimationEnterFrame]"); }
			var movieClipAnimation:MovieClip = event.target as MovieClip;
			if (_animationContainer.contains(movieClipAnimation)) {
				if (movieClipAnimation.currentFrame == movieClipAnimation.totalFrames) {
					movieClipAnimation.removeEventListener(Event.ENTER_FRAME, onAnimationEnterFrame);
					if (_nextAnimationName) {
						removeCurrentAnimation();
						play(_nextAnimationName);
						_nextAnimationName = null;
					}
				}
			} else { trace("container not contains animation movie clip [IcSprite.onAnimationEnterFrame]"); }
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
