package game {
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import scene.IScene;

	public class GameScene extends EventDispatcher implements IScene {
		private var _container:Sprite;
		
		public function GameScene(container:Sprite):void {
			super();
			_container = container;
		}
		
		public function open():void { }
		public function close():void { }
	}
}
