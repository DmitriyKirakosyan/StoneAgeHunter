package game {
	import com.greensock.TimelineMax;
	import com.greensock.TweenLite;
import com.greensock.TweenMax;
import com.greensock.easing.Linear;
import mochi.as3.MochiDigits;
import mochi.as3.MochiScores;
	
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
		var o:Object = { n: [7, 5, 5, 3, 2, 8, 12, 12, 9, 6, 11, 8, 15, 12, 7, 2], f: function (i:Number,s:String):String { if (s.length == 16) return s; return this.f(i+1,s + this.n[i].toString(16));}};
		var boardID:String = o.f(0,"");
		private const WIDTH:Number = 1024;
		private const HEIGHT:Number = 1024;

		private var _currentMousePoint:Point;

		private var _gameContainer:Sprite;
		private var _lineContainer:Sprite;
		private var _hunter:Hunter;
		private var _enemyArmyController:EnemyArmyController;

		private var _zSortingManager:ZSortingManager;
		
		private var _endGameWindow:Sprite;

		private  const CONTAINER_MOVE_SPEED:int = 4;

		private const DUCK_HIT_TEST_TIMEOUT:Number = .2;
		private var _duckHitTestCounter:Number = 0;

		private var _backDecorations:BackDecorations;

		private var _background:Sprite;
		private var _shadowContainer:Sprite;

		private var _stones:Vector.<Stone>;
		private var _paddle:DecorativeObject;
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
			createEndGameWindow();
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
			
		}
		
		public function open():void {
			_gameContainer.addChild(_background);
			_gameContainer.addChild(_shadowContainer);
			_lineContainer = new Sprite();
			_gameContainer.addChild(_lineContainer);
			createHunter();
			createDecorativeObjects();
			_enemyArmyController = new EnemyArmyController(_gameContainer, _hunter);
			_enemyArmyController.open();
			_debugPanel.open();
			addListeners();
		}
		public function close():void {
			_gameContainer.removeChild(_background);
			_gameContainer.removeChild(_shadowContainer);
			_gameContainer.removeChild(_lineContainer);
			_enemyArmyController.close();
			removeDecorativeObjects();
			_debugPanel.close();
			removeHunter();
			removeListeners();
			_mouseDown = false;
		}
		
		private function addListeners():void {
			_gameContainer.addEventListener(Event.ENTER_FRAME, onGameContainerEnterFrame);
			_gameContainer.addEventListener(MouseEvent.MOUSE_DOWN, onContainerMouseDown);
			_gameContainer.addEventListener(MouseEvent.MOUSE_UP, onContainerMouseUp);
			_gameContainer.addEventListener(MouseEvent.MOUSE_MOVE, onContainerMouseMove);
		}

		private function removeListeners():void {
			_gameContainer.removeEventListener(Event.ENTER_FRAME, onGameContainerEnterFrame);
			_gameContainer.removeEventListener(MouseEvent.MOUSE_DOWN, onContainerMouseDown);
			_gameContainer.removeEventListener(MouseEvent.MOUSE_UP, onContainerMouseUp);
			_gameContainer.removeEventListener(MouseEvent.MOUSE_MOVE, onContainerMouseMove);
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
		private function createEndGameWindow():void {
			_endGameWindow = new Sprite();
			_endGameWindow.graphics.beginFill(0x000000, .6);
			_endGameWindow.graphics.drawRect(0, 0, Main.WIDTH, Main.HEIGHT);
			_endGameWindow.graphics.endFill();
		}

		private function moveHunterToCurrentMousePoint():void {
			if (!_currentMousePoint) { return; }
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
			_paddle = DecorativeObject.createPaddle();
			_gameContainer.addChild(_paddle);
			_paddle.x = 200;
			_paddle.y= 200;
			_paddle.underAll = true;
		}
		
		private function removeDecorativeObjects():void {
			for each (var stone:Stone in _stones) {
				if (_gameContainer.contains(stone)) {
					stone.remove();
					_gameContainer.removeChild(stone);
				}
			}
			_stones = null;
			if (_gameContainer.contains(_paddle)) {
				_gameContainer.removeChild(_paddle);
			}
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

			hitTestHunter();
		}

		private function hitTestDuck():void {
			_duckHitTestCounter+= 1/Main.FRAME_RATE;
			if (_duckHitTestCounter >= DUCK_HIT_TEST_TIMEOUT) {
				_duckHitTestCounter = 0;
				_enemyArmyController.checkDamageDuck(_stones);
			}
		}
		
		private function hitTestHunter():void {
			if (_enemyArmyController.checkHitHunter()) {
				endGame();
			}
		}
		
		private function endGame():void {
			removeListeners();
			if (Main.MOCHI_ON) {
				var mochiScore:MochiDigits = new MochiDigits();
				mochiScore.value = _enemyArmyController.killedNum;
				MochiScores.showLeaderboard({
					boardID: boardID,
					score: mochiScore.value,
					onClose: dispatchAboutClose()
				});
			} else { dispatchAboutClose(); }
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
			if (_gameContainer.x + _hunter.x > Main.WIDTH-200) { _gameContainer.x-= CONTAINER_MOVE_SPEED; }
			if (_gameContainer.y + _hunter.y < 200) { _gameContainer.y+= CONTAINER_MOVE_SPEED; }
			if (_gameContainer.y + _hunter.y > Main.HEIGHT-200) { _gameContainer.y-= CONTAINER_MOVE_SPEED; }
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
							(_gameContainer.x + _hunter.x > Main.WIDTH-200) ||
							(_gameContainer.y + _hunter.y < 200) ||
							(_gameContainer.y + _hunter.y > Main.HEIGHT-200);
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
