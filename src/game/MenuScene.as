package game {
	import scene.SceneEvent;
	import flash.events.MouseEvent;
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
			_button.y = Main.HEIGHT / 2 - _button.height / 2;
			addButtonListeners();
		}

		public function open() : void {
			_container.addChild(_button);
		}

		public function close() : void {
			_container.removeChild(_button);
		}
		
		/* Internal functinos */

		private function createBackground():void {
			_background = new Sprite();
			_background.graphics.beginFill(0x4ff4cf);
			_background.graphics.drawRect(0, 0, Main.WIDTH, Main.WIDTH);
			_background.graphics.endFill();
		}
		
		private function addButtonListeners():void {
			_button.addEventListener(MouseEvent.CLICK, onMouseClick);
			_button.addEventListener(MouseEvent.MOUSE_OVER, onButtonMouseOver);
			_button.addEventListener(MouseEvent.MOUSE_OUT, onButtonMouseOut);
		}
		
		private function onMouseClick(event:MouseEvent):void {
			dispatchEvent(new SceneEvent(SceneEvent.SWITCH_ME, this));
		}
		
		private function onButtonMouseOver(event:MouseEvent):void {
			_button.gotoAndStop(2);
			//_button.filters = [new GlowFilter(0x000000)];
		}
		private function onButtonMouseOut(event:MouseEvent):void {
			_button.gotoAndStop(1);
			//_button.filters = [];
		}
	}
}
