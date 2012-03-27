package game.iface {
	import flash.display.Sprite;
	import game.iface.component.ScoreComponent;
	/**
	 * ...
	 * @author Dima
	 */
	public class InterfaceController {
		private var _container:Sprite;
		private var _scoreComponent:ScoreComponent;
		
		public function InterfaceController(container:Sprite) {
			_container = container;
			_scoreComponent = new ScoreComponent();
		}

		public function get scoreComponent():ScoreComponent { return _scoreComponent; }
		
		public function open():void {
			_container.addChild(_scoreComponent);
			_scoreComponent.setScore(0);
		}
		
		public function close():void {
			_container.removeChild(_scoreComponent);
		}
		
	}

}