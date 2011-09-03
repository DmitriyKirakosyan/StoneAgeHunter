package game{
	import flash.events.MouseEvent;
	import game.hunters.HuntersController;
	import game.animals.AnimalsController;
	import flash.display.Sprite;
	public class GameController {
		private var _container:Sprite;
		
		private var _animalsController:AnimalsController;
		private var _huntersController:HuntersController;
		
		public static const GAME_WIDTH:Number = 300;
		public static const GAME_HEIGHT:Number = 300;
		
		public function GameController(container:Sprite):void {
			super();
			_container = container;
			_container.x = 50;
			_container.y = 50;
			drawGameRect();
			initControllers();
			addStageListeners();
		}
		
		/* Internal functions */
		
		private function drawGameRect():void {
			_container.graphics.beginFill(0xa0c1b0);
			_container.graphics.drawRect(0, 0, GAME_WIDTH, GAME_HEIGHT);
			_container.graphics.endFill();
			_container.graphics.lineStyle(2, 0x0fa2aa);
			_container.graphics.moveTo(0, 0);
			_container.graphics.lineTo(0, GAME_HEIGHT);
			_container.graphics.lineTo(GAME_WIDTH, GAME_HEIGHT);
			_container.graphics.lineTo(GAME_WIDTH, 0);
			_container.graphics.lineTo(0, 0);
		}
		
		private function initControllers():void {
			_animalsController = new AnimalsController(_container);
			_animalsController.createAnimals();
			_huntersController = new HuntersController(_container);
			_huntersController.createHunters();
		}
		
		private function addStageListeners():void {
			_container.addEventListener(MouseEvent.CLICK, onStageClick);
		}
		
		private function onStageClick(event:MouseEvent):void {
			
		}
		
	}
}
