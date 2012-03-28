package game {
	import com.greensock.TimelineMax;
	import com.greensock.TweenLite;
import com.greensock.TweenMax;
import com.greensock.easing.Linear;

import game.armor.StonesCollector;
import game.decorate.DecoratesCreator;
import game.enemy.EnemyArmyEvent;
import game.iface.InterfaceController;

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
		public static const WIDTH:Number = 1024;
		public static const HEIGHT:Number = 1024;

		private var _currentMousePoint:Point;

		private var _gameContainer:Sprite;
		private var _ifaceContainer:Sprite;
//		private var _arrowContainer:Sprite;
		private var _interface:InterfaceController;
		private var _lineContainer:Sprite;
		private var _hunter:Hunter;
		private var _enemyArmyController:EnemyArmyController;

		private var _zSortingManager:ZSortingManager;
		
		private var _endGameWindow:Sprite;

		private  const CONTAINER_MOVE_SPEED:int = 4;

		private const DUCK_HIT_TEST_TIMEOUT:Number = .2;
		private var _duckHitTestCounter:Number = 0;

		private var _background:Sprite;
		private var _shadowContainer:Sprite;

		//private var _arrow:Sprite;

		private var _stonesCollector:StonesCollector;
		private var _debugPanel:DebugPanel;
		//private var _debugConsole:DebugConsole;
		
		private var _decoratesCreator:DecoratesCreator;
		
		public var active:Boolean = true;
		
		private var _mouseDown:Boolean;
		
		public function GameScene(container:Sprite, tileMap:TileMap):void {
			super();
			//_arrow = new Arrow2();
			//_arrow.scaleX = _arrow.scaleY = 3;
			_gameContainer = new Sprite();
			_ifaceContainer = new Sprite();
//			_arrowContainer = new Sprite();

			_shadowContainer =  new Sprite();
			_stonesCollector = new StonesCollector(_gameContainer);
			_interface = new InterfaceController(_ifaceContainer);
			createBackground();
			createEndGameWindow();
			_decoratesCreator = new DecoratesCreator();
			_gameContainer.x = -400;
			_gameContainer.y = -200;
			_debugPanel = new DebugPanel(container, this);
			_zSortingManager = new ZSortingManager(this);
			container.addChild(_gameContainer);
			container.addChild(_ifaceContainer);
//			container.addChild(_arrowContainer);
			
		}
		
		public function open():void {
			_gameContainer.addChild(_background);
			_gameContainer.addChild(_shadowContainer);
			_interface.open();
			_lineContainer = new Sprite();
			_gameContainer.addChild(_lineContainer);
			createHunter();
			_decoratesCreator.create();
			_gameContainer.addChild(_decoratesCreator.container);
			_enemyArmyController = new EnemyArmyController(_gameContainer, _hunter);
			_enemyArmyController.open();
			_debugPanel.open();
			addListeners();
		}
		public function close():void {
			_gameContainer.removeChild(_background);
			_gameContainer.removeChild(_shadowContainer);
			_gameContainer.removeChild(_lineContainer);
			_interface.close();
			_enemyArmyController.close();
			_decoratesCreator.remove();
			_gameContainer.removeChild(_decoratesCreator.container);
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
			_enemyArmyController.addEventListener(EnemyArmyEvent.ENEMY_KILLED, onEnemyKilled);
		}

		private function removeListeners():void {
			_gameContainer.removeEventListener(Event.ENTER_FRAME, onGameContainerEnterFrame);
			_gameContainer.removeEventListener(MouseEvent.MOUSE_DOWN, onContainerMouseDown);
			_gameContainer.removeEventListener(MouseEvent.MOUSE_UP, onContainerMouseUp);
			_gameContainer.removeEventListener(MouseEvent.MOUSE_MOVE, onContainerMouseMove);
			_enemyArmyController.removeEventListener(EnemyArmyEvent.ENEMY_KILLED, onEnemyKilled);
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

		private function onEnemyKilled(event:EnemyArmyEvent):void {
			_interface.scoreComponent.setScore(_enemyArmyController.killedNum);
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

		public function get gameContainer():Sprite { return _gameContainer; }

		public function get hunter():Hunter { return _hunter; }
		
		public function dispatchAboutClose():void {
			dispatchEvent(new SceneEvent(SceneEvent.SWITCH_ME, this));
		}

		/* Internal functions */
		
		private function onGameContainerEnterFrame(event:Event):void {
			_zSortingManager.checkZSorting();
			if (!_hunter) { return; }
			if (mouseAroundSide()) {
				scrollContainer();
			}

			_hunter.tick();
			if (_hunter.canThrowStone) {
				_hunter.throwStone();
				throwStoneToDuck();
			}

			hitTestDuck();

			if (_mouseDown) {
				drawLineBetweenHunterAndMouse();
				//correctArrow();
			} else { _lineContainer.graphics.clear(); }

			hitTestHunter();
		}

		private function hitTestDuck():void {
			_duckHitTestCounter+= 1/Main.FRAME_RATE;
			if (_duckHitTestCounter >= DUCK_HIT_TEST_TIMEOUT) {
				_duckHitTestCounter = 0;
				_enemyArmyController.checkDamageDuck(_stonesCollector.stones);
			}
		}
		
		private function hitTestHunter():void {
			if (_enemyArmyController.checkHitHunter()) {
				endGame();
			}
		}
		
		private function endGame():void {
			removeListeners();
			if (Main.MOCHI_ON && _enemyArmyController.killedNum > 0) {
				var mochiScore:MochiDigits = new MochiDigits();
				mochiScore.value = _enemyArmyController.killedNum;
				MochiScores.showLeaderboard({
					boardID: boardID,
					score: mochiScore.value,
					onClose: dispatchAboutClose()
				});
			} else { dispatchAboutClose(); }
		}

//		private function correctArrow():void {
//			if (!_currentMousePoint) { return; }
//			_arrow.x = _currentMousePoint.x;
//			_arrow.y = _currentMousePoint.y;

//			var distance:Number = Point.distance(new Point(_hunter.x, _hunter.y), _gameContainer.globalToLocal(_currentMousePoint));
//			var angle:Number = Math.acos(_hunter.x/distance) / 3.14 * 180;
//			trace("angle for arrow : " + angle + ", distance : " + distance + " [GameScene.correctArrow]");
//			_arrow.rotation = angle;
//		}
		
		private function drawLineBetweenHunterAndMouse():void {
			if (!_currentMousePoint) { return; }
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

		private function throwStoneToDuck():void {
			var duckForShoot:Duck = _enemyArmyController.getDuckForShoot();
			var toPoint = duckForShoot ? new Point(duckForShoot.x, duckForShoot.y)
															 : new Point(Math.random()*WIDTH, Math.random() * HEIGHT);
			var stone:Stone = new Stone(_shadowContainer);
			_stonesCollector.addStone(stone);
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
//			_arrow.x = event.stageX;
//			_arrow.y = event.stageY;
//			_arrowContainer.addChild(_arrow);
			if(_hunter){
				moveHunterToCurrentMousePoint();
			}
		}
		protected function onContainerMouseUp(event:MouseEvent):void {
			_mouseDown = false;
//			_arrowContainer.removeChild(_arrow);
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
