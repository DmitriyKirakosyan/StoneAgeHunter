package game {
	import com.greensock.TimelineMax;
	import com.greensock.TweenLite;
import com.greensock.TweenMax;
import com.greensock.easing.Linear;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
import flash.filters.BlurFilter;
import flash.geom.Point;

import game.animal.Duck;

import game.armor.Stone;

import game.debug.DebugConsole;
	import game.debug.DebugPanel;
import game.enemy.EnemyArmyController;
import game.player.Hunter;
	
	import scene.IScene;
	import scene.SceneEvent;
	
	import game.map.tilemap.TileMap;

	public class GameScene extends EventDispatcher implements IScene {
		private const WIDTH:Number = 1024;
		private const HEIGHT:Number = 1024;

		private const WINDOW_WIDTH:Number = 550;
		private const WINDOW_HEIGHT:Number = 400;

		private var _currentMousePoint:Point;

		private var _gameContainer:Sprite;
		private var _lineContainer:Sprite;
		private var _hunter:Hunter;
		private var _enemyArmyController:EnemyArmyController;

		private var _zSortingManager:ZSortingManager;
		//private var _parallaxManager:ParallaxManager;
		//private var _perspectiveManager:PerspectiveManager;

		private  const CONTAINER_MOVE_SPEED:int = 4;

		private const DUCK_HIT_TEST_TIMEOUT:Number = .2;
		private var _duckHitTestCounter:Number = 0;

		private var _backDecorations:BackDecorations;

		private var _background:Sprite;
		private var _shadowContainer:Sprite;

		private var _stones:Vector.<Stone>;
		private var _decorativeObjects:Vector.<DecorativeObject> = new Vector.<DecorativeObject>;
		
		private var _debugPanel:DebugPanel;
		//private var _debugConsole:DebugConsole;
		
		public var active:Boolean = true;
		
		private var _mouseDown:Boolean;
		
		public function GameScene(container:Sprite, tileMap:TileMap):void {
			super();
			_gameContainer = new Sprite();
			_shadowContainer =  new Sprite();
			createBackground();
//			_gameContainer.graphics.beginFill(0,.2);
//			_gameContainer.graphics.drawRect(0,0,WIDTH,HEIGHT);
//			_gameContainer.graphics.endFill();
			_gameContainer.x = -400;
			_gameContainer.y = -200;
			_debugPanel = new DebugPanel(container, this);
			//_debugConsole = new DebugConsole(this);
			_zSortingManager = new ZSortingManager(this);
			//_parallaxManager = new ParallaxManager(this);
			//_perspectiveManager = new PerspectiveManager(this);
			//backDecorations = new BackDecorations;
			//gameContainer.addChild(backDecorations);
			container.addChild(_gameContainer);
			_gameContainer.addEventListener(Event.ENTER_FRAME, onGameContainerEnterFrame);
			container.addEventListener(MouseEvent.MOUSE_DOWN, onContainerMouseDown);
			container.addEventListener(MouseEvent.MOUSE_UP, onContainerMouseUp);
			container.addEventListener(MouseEvent.MOUSE_MOVE, onContainerMouseMove);
			
		}
		
		public function open():void {
			_gameContainer.addChild(_background);
			_gameContainer.addChild(_shadowContainer);
			//_parallaxManager.open();
			_lineContainer = new Sprite();
			_gameContainer.addChild(_lineContainer);
			createHunter();
			createDecorativeObjects();
			_enemyArmyController = new EnemyArmyController(_gameContainer, _hunter);
			_enemyArmyController.open();
			_debugPanel.open();
		}
		public function close():void {
			_gameContainer.removeChild(_background);
			_gameContainer.removeChild(_shadowContainer);
			_enemyArmyController.close();
			//_parallaxManager.close();
			_debugPanel.close();
			_gameContainer.removeChild(_lineContainer);
			removeHunter();
		}

		protected function onContainerMouseMove(event:MouseEvent):void
		{
			if (!_currentMousePoint) { _currentMousePoint = new Point(); }
			_currentMousePoint.x = event.stageX;
			_currentMousePoint.y = event.stageY;
			if(_hunter && _mouseDown){
				moveHunterToCurrentMousePoint();
			}
		}

		private function createBackground():void {
			_background = new Sprite();
			var groundM2:GroundM;
			for (var i:int = 0; i < 16; ++i) {
				for (var j:int = 0; j < 16; ++j) {
					groundM2 = new GroundM();
					groundM2.x = i * 64;
					groundM2.y = j * 64;
					_background.addChild(groundM2);
				}
			}
		}

		private function moveHunterToCurrentMousePoint():void {
			_hunter.move();
			var toPoint:Point = new Point(_currentMousePoint.x - _gameContainer.x,
							         							_currentMousePoint.y - _gameContainer.y);
			TweenLite.killTweensOf(_hunter);
			_hunter.changeAnimationAndRotation(toPoint);
			TweenLite.to(_hunter,
				_hunter.computeDuration(new Point(_hunter.x, _hunter.y), toPoint),
				{ease:Linear.easeNone, realXpos : toPoint.x, y : toPoint.y,
					onComplete : function():void {_hunter.stop();}});
		}
		
		/* functions for debug */
		
		public function get allObjects():Array {
			var newArray:Array = new Array();

			return newArray;
		}

		public function get decorativeObjects():Vector.<DecorativeObject> {
			return _decorativeObjects;
		}

		public function get stones():Vector.<Stone> { return _stones; }

		public function get backDecorations():BackDecorations
		{
			return _backDecorations;
		}

		public function set backDecorations(value:BackDecorations):void
		{
			_backDecorations = value;
		}

		public function get gameContainer():Sprite { return _gameContainer; }

		public function get hunter():Hunter { return _hunter; }
		
		public function dispatchAboutClose():void {
			dispatchEvent(new SceneEvent(SceneEvent.SWITCH_ME, this));
		}

		private function addStone():void {
			var stone:Stone = new Stone(_shadowContainer);
			stone.realXpos = Math.random() * (WIDTH-100) + 50;
			_gameContainer.addChild(stone);
			stone.y = Math.random() * (HEIGHT-100) +50;
			if (!_stones) { _stones = new Vector.<Stone>(); }
			_stones.push(stone);
		}

		//делаем всякие камушки - хуямушки
		private function createDecorativeObjects():void {
			for (var i:int = 0; i < 10; i++){
				addStone();
			}
			var decorate:DecorativeObject;
			decorate = DecorativeObject.createPaddle();
			decorativeObjects.push(decorate)
			_gameContainer.addChild(decorate);
			decorate.realXpos = 200;
			decorate.y= 200;
			decorate.underAll = true;
		}
		
		/* Internal functions */
		
		private function onGameContainerEnterFrame(event:Event):void {
			_zSortingManager.checkZSorting();
			if (!_hunter) { return; }
			if (mouseAroundSide()) {
				scrollContainer();
			}

			for each (var stone:Stone in _stones) {
				if (_hunter.hitTestObject(stone) && !stone.flying) {
					_hunter.throwStone();
					throwStoneToDuck(stone);
					break;
				}
			}

			hitTestDuck();

			if (_mouseDown) { drawLineBetweenHunterAndMouse(); } else { _lineContainer.graphics.clear(); }
		}

		private function hitTestDuck():void {
			_duckHitTestCounter+= 1/Main.FRAME_RATE;
			if (_duckHitTestCounter >= DUCK_HIT_TEST_TIMEOUT) {
				_duckHitTestCounter = 0;
				_enemyArmyController.checkDamageDuck(_stones);
			}
		}

		private function drawLineBetweenHunterAndMouse():void {
			_lineContainer.graphics.clear();
			_lineContainer.graphics.lineStyle(2);
			_lineContainer.graphics.moveTo(_hunter.x,  _hunter.y);
			_lineContainer.graphics.lineTo(_currentMousePoint.x - _gameContainer.x,
																	 _currentMousePoint.y - _gameContainer.y);
		}

		private function scrollContainer():void {
			if (_gameContainer.x + _hunter.x < 200) { _gameContainer.x += CONTAINER_MOVE_SPEED; }
			if (_gameContainer.x + _hunter.x > WINDOW_WIDTH-200) { _gameContainer.x-= CONTAINER_MOVE_SPEED; }
			if (_gameContainer.y + _hunter.y < 200) { _gameContainer.y+= CONTAINER_MOVE_SPEED; }
			if (_gameContainer.y + _hunter.y > WINDOW_HEIGHT-200) { _gameContainer.y-= CONTAINER_MOVE_SPEED; }
		}

		private function throwStoneToDuck(stone:Stone):void {
			var duckForShoot:Duck = _enemyArmyController.getDuckForShoot();
			var toPoint = duckForShoot ? new Point(duckForShoot.x, duckForShoot.y)
															 : new Point(Math.random()*WIDTH, Math.random() * HEIGHT);
			stone.x = _hunter.x;
			stone.y = _hunter.y;
			stone.fly(toPoint);
		}

		private function mouseAroundSide():Boolean {
			return (_gameContainer.x + _hunter.x < 200) ||
							(_gameContainer.x + _hunter.x > WINDOW_WIDTH-200) ||
							(_gameContainer.y + _hunter.y < 200) ||
							(_gameContainer.y + _hunter.y > WINDOW_HEIGHT-200);
		}

		private function onContainerMouseDown(event:MouseEvent):void {
			_mouseDown = true;
			if(_hunter){
				moveHunterToCurrentMousePoint();
			}
		//	_parallaxManager.deactivateIfNot();
		}
		protected function onContainerMouseUp(event:MouseEvent):void {
			_mouseDown = false;
		//	_parallaxManager.activateIfNot();
		}


		private function createHunter():void {
			trace("createHunter");
			_hunter = new Hunter(false);
			//_hunter.realXpos = 350;
			//_hunter.y = 300;
			_gameContainer.addChild(_hunter);
		}
		
		private function removeHunter():void {
			_gameContainer.removeChild(_hunter);
		}
		
		
	}
}
