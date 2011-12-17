package game
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class ParallaxManager
	{
		private var _gameScene:GameScene;
		private var _screenCenterX:int;
		private var _stage:Stage;
		private var parallaxForce:Number = 0.2;
		public function ParallaxManager(gameScene:GameScene)
		{
			_gameScene = gameScene;
			//хз как на самом деле правильно было бы здесь слушать движения мышки;
			_gameScene.gameContainer.addEventListener(Event.ADDED_TO_STAGE, onGameContainerAddedToStage);
		}
		
		protected function onGameContainerAddedToStage(event:Event):void
		{
			_gameScene.gameContainer.removeEventListener(Event.ADDED_TO_STAGE, onGameContainerAddedToStage);
			_stage = _gameScene.gameContainer.stage;
			_screenCenterX = _gameScene.gameContainer.stage.stageWidth/2;
			_gameScene.gameContainer.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
		}
		
		protected function onMouseMove(event:MouseEvent):void
		{
			if(_gameScene.active){
				updateObjectPositions(_screenCenterX - _stage.mouseX);
			}
		}
		
		private function updateObjectPositions(param0:int):void
		{
			_gameScene.backDecorations.offsetX = param0;
		}
	}
}