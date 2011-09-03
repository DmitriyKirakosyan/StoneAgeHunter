package game.hunters {
	import flash.display.Sprite;
	import flash.events.EventDispatcher;

	public class HunterPathController extends EventDispatcher {
		private var _container:Sprite;
		private var _clickedHunter:Hunter;
		
		public function HunterPathController(container:Sprite) {
			super();
			_container = container;
		}
		
		public function setClickedHunter(hunter:Hunter):void{
			_clickedHunter = hunter;
		}
	}
}
