package animation {
	import flash.display.BitmapData;
	import flash.display.Sprite;

	public class IcSprite extends Sprite {
		private var _animations:Vector.<IcAnimation>;
		
		public function IcSprite() {
			super();
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
			
		}
		
		private function getAnimationByName(name:String):IcAnimation {
			for each (var icAnimation:IcAnimation in _animations) {
				if (icAnimation.name == name) { return icAnimation; }
			}
			return null;
		}
	}
}
