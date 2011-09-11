package game {
	import scene.SceneEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import scene.IScene;

	public class MenuScene extends EventDispatcher implements IScene {
		private var _container:Sprite;
		
		private var _menuText:TextField;

		public function MenuScene(container:Sprite):void {
			super();
			_container = container;
		}
		
		public function open() : void {
			_menuText = new TextField();
			_menuText.text = "Menu";
			_menuText.x = 150;
			_menuText.y = 100;
			_container.addChild(_menuText);
			addListeners();
		}

		public function close() : void {
			_container.removeChild(_menuText);
			removeListeners();
		}
		
		/* Internal functinos */
		
		private function addListeners():void {
			_container.stage.addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		private function removeListeners():void {
			_container.stage.removeEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		private function onMouseClick(event:MouseEvent):void {
			dispatchEvent(new SceneEvent(SceneEvent.SWITCH_ME, this));
		}
	}
}
