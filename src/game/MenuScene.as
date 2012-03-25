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
		private var _background:Sprite;

		public function MenuScene(container:Sprite):void {
			super();
			_container = container;
			createBackground();
			_menuText = new TextField();
			_menuText.text = "Menu";
			_menuText.x = 150;
			_menuText.y = 100;
			_menuText.selectable = false;
		}
		
		public function open() : void {
			//_container.addChild(_background);
			_container.addChild(_menuText);
			addListeners();
		}

		public function close() : void {
			//_container.removeChild(_background);
			_container.removeChild(_menuText);
			removeListeners();
		}
		
		/* Internal functinos */

		private function createBackground():void {
			_background = new Sprite();
			_background.graphics.beginFill(0x4ff4cf);
			_background.graphics.drawRect(0, 0, Main.WIDTH, Main.WIDTH);
			_background.graphics.endFill();
		}
		
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
