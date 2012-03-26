package game {
	import scene.SceneEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import scene.IScene;

	public class MenuScene extends EventDispatcher implements IScene {
		private var _container:Sprite;
		private var _background:Sprite;
		private var _button:PlayBtnView;

		public function MenuScene(container:Sprite):void {
			super();
			_container = container;
			createBackground();

			_button = new PlayBtnView();
			_button.x = Main.WIDTH/2 - _button.width/2;
			_button.y = Main.HEIGHT/2 - _button.height/2;
		}

		public function open() : void {
			_container.addChild(_button);
			addListeners();
		}

		public function close() : void {
			_container.removeChild(_button);
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
			_button.addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		private function removeListeners():void {
			_button.removeEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		private function onMouseClick(event:MouseEvent):void {
			dispatchEvent(new SceneEvent(SceneEvent.SWITCH_ME, this));
		}
	}
}
