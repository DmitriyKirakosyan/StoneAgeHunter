package game
{
	import animation.IcSprite;

import flash.display.Sprite;

import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
import flash.geom.Point;

public class ParallaxManager
	{
		private var _gameScene:GameScene;
		private var _gameContainer:Sprite;
		private var _screenCenterX:int;
		private var _stage:Stage;
		private var _active:Boolean;
		private var _currentMousePosX:Number;
		private var parallaxForce:Number = 0.2;


		public function ParallaxManager(gameScene:GameScene) {
			_gameScene = gameScene;
			_gameContainer = _gameScene.gameContainer;
			_stage = _gameContainer.stage;
			_screenCenterX = Main.WIDTH/2;
		}

		public function open():void {
			_gameContainer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_gameContainer.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			_active = true;
		}
		public function close():void {
			_gameContainer.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_gameContainer.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			_active = false;
		}

		public function deactivateIfNot():void {
			_active = false;
		}
		public function activateIfNot():void {
			_active = true;
		}

		private function onMouseMove(event:MouseEvent):void {
			if(_active){
				_currentMousePosX = event.stageX;
			}
		}

		private function onEnterFrame(event:Event):void {
			if (_active) {
				updateObjectPositions(_screenCenterX - _currentMousePosX);
			}
		}

		private function updateObjectPositions(param0:int):void {
			//_gameScene.backDecorations.offsetX = param0;
			if(_gameScene.hunter){
				_gameScene.hunter.parallaxOffset = param0;
			}
			for each (var object:IcSprite in _gameScene.stones){
				object.parallaxOffset = param0;
			}
			for each (object in _gameScene.decorativeObjects){
				object.parallaxOffset = param0;
			}
		}
	}
}