package animation {
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.display.BitmapData;
	import flash.display.Sprite;

	public class IcSprite extends Sprite {
		private var _animations:Vector.<IcAnimation>;
		private var _animating:Boolean;
		private var _currentAnimation:IcAnimation;
		private var _currentBitmap:Bitmap;
		private var _framesCounter:uint;
		
		public function IcSprite() {
			super();
			_animating = false;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		/* API */
		
		public function addAnimation(name:String, duration:Number, frames:Vector.<BitmapData>):void {
			if (!_animations) { _animations = new Vector.<IcAnimation>(); }
			_animations.push(new IcAnimation(name, duration, frames));
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
			if (_animating) {
				removeFrameListener();
				this.removeChild(_currentBitmap);
			}
			_currentAnimation = icAnimation;
			_currentBitmap = new Bitmap(_currentAnimation.bitmapData);
			this.addChild(_currentBitmap);
			_framesCounter = 0;
			_animating = true;
			addFrameListener();
			
		}
		
		private function getAnimationByName(name:String):IcAnimation {
			for each (var icAnimation:IcAnimation in _animations) {
				if (icAnimation.name == name) { return icAnimation; }
			}
			return null;
		}
		
		private function onAddedToStage(event:Event):void {
		}
		
		private function onEnterFrame(event:Event):void {
			if (_framesCounter <= 0) {
				_currentAnimation.currentFrame = _currentAnimation.currentFrame + 1;
				_framesCounter = _currentAnimation.duration;
			} else {
				_framesCounter--;
			}
		}
		
		private function addFrameListener():void {
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		private function removeFrameListener():void {
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
	}
}
