package game {
	import game.player.Hunter;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import com.bit101.components.PushButton;
	public class DebugPanel {
		private var _gameSceneContainer:Sprite;
		private var _container:Sprite;
		private var _gameScene:GameScene;
	
		private var _goBtn:PushButton;
		private var _attackBtn:PushButton;
		private var _pauseBtn:PushButton;
		private var _clearBtn:PushButton;
		private var _goMenuBtn:PushButton;
		
		public function DebugPanel(container:Sprite, gameScene:GameScene):void {
			super();
			_gameSceneContainer = container;
			_container = new Sprite();
			_gameScene = gameScene;
			createButtons();
		}
		
		public function open():void {
			addButtons();
		}
		
		public function close():void {
			removeButtons();
		}
		
		/* Internal functions */
		
		//TODO bad memory managment here, forgot remove listeners
		
		private function createButtons():void {
			_goBtn = new PushButton(_container, 400, 50, "lets go", onButtonGoClick);
			_attackBtn = new PushButton(_container, 400, 70, "attack", onButtonAttackClick);
			_pauseBtn = new PushButton(_container, 400, 90, "pause", onButtonPauseClick);
			_clearBtn = new PushButton(_container, 400, 110, "clear", onButtonClearClick);
			_goMenuBtn = new PushButton(_container, 400, 130, "go to menu", onButtonMenuClick);
		}
		
		private function addButtons():void {
			_gameSceneContainer.addChild(_container);
		}
		
		private function removeButtons():void {
			if (_gameSceneContainer.contains(_container)) {
				_gameSceneContainer.removeChild(_container);
			}
		}
		
		private function onButtonGoClick(event:MouseEvent):void {
			_gameScene.drawing = false;
			for each (var hunter:Hunter in _gameScene.hunters) {
				hunter.move();
			}
			_gameScene.drawingContainer.graphics.clear();
		}
		
		private function onButtonAttackClick(event:MouseEvent):void {
			_gameScene.reFillLastWayPoint();
		}
		
		private function onButtonPauseClick(event:MouseEvent):void {
			for each (var hunter:Hunter in _gameScene.hunters) {
				hunter.pauseMove();
			}
			_gameScene.drawPaths();
		}
		
		private function onButtonClearClick(event:MouseEvent):void {
			_gameScene.drawingContainer.graphics.clear();
			_gameScene.drawing = false;
		}
		
		private function onButtonMenuClick(event:MouseEvent):void {
			event.stopPropagation();
			_gameScene.dispatchAboutClose();
		}
		
	}
}
