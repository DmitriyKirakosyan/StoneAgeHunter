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
		}
		
		public function open():void {
			_container.addChild(_scoreComponent);
		}
		
		public function close():void {
			_container.removeChild(_scoreComponent);
		}
		
	}

}