package utils {
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.utils.Timer;
	import flash.display.Sprite;

	public class TwistingDot extends Sprite {
		private var _timer:Timer;
		private var _dotContainer:Sprite;
		private var _radius:int;
		
		public function TwistingDot(radius:int = 10) {
			super();
			_radius = radius;
			createDotContainer();
			drawDot();
			_timer = new Timer(100);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
		}
		
		public function start():void {
			startTimer();
		}
		public function stop():void {
			stopTimer();
		}
		
		private function createDotContainer():void {
			_dotContainer = new Sprite();
			this.addChild(_dotContainer);
		}
		
		private function drawDot():void {
			_dotContainer.graphics.beginFill(0xd1d1d1);
			_dotContainer.graphics.drawCircle(0, -_radius, 2);
			_dotContainer.graphics.endFill();
			_dotContainer.filters = [new GlowFilter(0xffffff)];
		}
		
		private function startTimer():void {
			_timer.start();
		}
		private function stopTimer():void {
			_timer.stop();
		}
		
		private function onTimer(event:TimerEvent):void {
			_dotContainer.rotation+= 15;
			if (_dotContainer.rotation >= 360) { _dotContainer.rotation = 0; }
		}
	}
}
