package game {
	import animation.IcSprite;
	import game.animals.AnimalEvent;
	import game.armor.Stone;
	import game.animals.Duck;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import scene.SceneEvent;
	import flash.geom.Point;
	import flash.events.MouseEvent;
	import game.player.Hunter;
	import tilemap.TileMap;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import scene.IScene;

	public class GameScene extends EventDispatcher implements IScene {
		private var _mapContainer:Sprite;
		private var _gameContainer:Sprite;
		private var _tileMap:TileMap;
		private var _hunters:Vector.<Hunter>;
		private var _duck:Duck;
		private var _stones:Vector.<Stone>;
		
		private var _debugPanel:DebugPanel;
		
		private var _drawingContainer:Sprite;
		private var _drawing:Boolean;
		private var _moving:Boolean;
		private var _selectedHunter:Hunter;
		
		public function GameScene(container:Sprite, tileMap:TileMap):void {
			super();
			_mapContainer = new Sprite();
			_gameContainer = new Sprite();
			_debugPanel = new DebugPanel(_gameContainer, this);
			container.addChild(_mapContainer);
			container.addChild(_gameContainer);
			_gameContainer.addEventListener(Event.ENTER_FRAME, onGameContainerEnterFrame);
			_tileMap = tileMap;
			_drawingContainer = new Sprite();
		}
		
		/* functions for debug */
		
		public function get hunters():Vector.<Hunter> {
			return _hunters;
		}
		
		public function get duck():Duck { return _duck; }
		
		public function set drawing(value:Boolean):void {
			_drawing = value;
		}
		
		public function get drawingContainer():Sprite {
			return _drawingContainer;
		}
		
		public function dispatchAboutClose():void {
			dispatchEvent(new SceneEvent(SceneEvent.SWITCH_ME, this));
		}
		
		public function open():void {
			_drawing = false;
			_moving = false;
			_mapContainer.addChild(_tileMap);
			createHunters();
			createDuck();
			createStones();
			_mapContainer.addChild(_drawingContainer);
			addListeners();
			_debugPanel.open();
		}
		public function close():void {
			_debugPanel.close();
			removeListeners();
			_mapContainer.removeChild(_tileMap);
			removeDuck();
			removeHunters();
			removeStones();
			_mapContainer.removeChild(_drawingContainer);
			_drawingContainer.graphics.clear();
		}
		
		public function play():void {
			_drawing = false;
			for each (var hunter:Hunter in _hunters) {
				hunter.move();
			}
			_duck.move();
			if (_selectedHunter) {
				for each (var keyPoint:KeyPoint in _selectedHunter.path.points) {
					_drawingContainer.removeChild(keyPoint);
				}
			}
			_drawingContainer.graphics.clear();
		}
		
		public function pause():void {
			for each (var hunter:Hunter in _hunters) {
				hunter.pauseMove();
			}
			_duck.pauseMove();
			drawPaths();
		}
		
		/* Internal functions */
		
		public function drawPaths():void {
			for each (var hunter:Hunter in _hunters) {
				drawHunterExistingPath(hunter);
			}
		}
		private function onGameContainerEnterFrame(event:Event):void {
			for each (var hunter:Hunter in _hunters) {
				checkWithAll(hunter);
			}
		}
		
		private function checkWithAll(hunter:Hunter):void {
			for each (var otherHunter:Hunter in _hunters) {
				if (hunter != otherHunter &&
						crossHunters(hunter, otherHunter) && needSwitchHunters(hunter, otherHunter)) {
					const indexOfOne:int = _gameContainer.getChildIndex(hunter);
					_gameContainer.setChildIndex(hunter, _gameContainer.getChildIndex(otherHunter));
					_gameContainer.setChildIndex(otherHunter, indexOfOne);
				}
			}
		}
		
		private function needSwitchHunters(one:Hunter, two:Hunter):Boolean {
			return (one.y > two.y && _gameContainer.getChildIndex(one) < _gameContainer.getChildIndex(two)) ||
							(one.y < two.y && _gameContainer.getChildIndex(one) > _gameContainer.getChildIndex(two));
		}
		
		private function crossHunters(one:Hunter, two:Hunter):Boolean {
			return one.hitTestObject(two);
		}
		
		private function createHunter():Hunter {
			const hunter:Hunter = new Hunter();
			hunter.x = Math.random() * 250 + 50;
			hunter.y = Math.random() * 150 + 50;
			_gameContainer.addChild(hunter);
			addHunterListeners(hunter);
			return hunter;
		}
		
		private function createHunters():void {
			_hunters = new Vector.<Hunter>();
			for (var i:int = 0; i < 3; ++i) {
				_hunters.push(createHunter());
			}
		}
		
		private function removeHunters():void {
			for each (var hunter:Hunter in _hunters) {
				removeHunterListeners(hunter);
				_gameContainer.removeChild(hunter);
			}
			_hunters = null;
		}
		
		private function createDuck():void {
			_duck = new Duck();
			for each (var hunter:Hunter in _hunters) { _duck.addEnemy(hunter); }
			_duck.x = Math.random() * 100 + 100;
			_duck.y = Math.random() * 100 + 100;
			_duck.updateTarget();
			addAnimalListeners(_duck);
			_gameContainer.addChild(_duck);
		}
		private function removeDuck():void {
			removeAnimalListeners(_duck);
			_gameContainer.removeChild(_duck);
		}
		
		private function createStones():void {
			var stone:Stone;
			_stones = new Vector.<Stone>();
			for (var i:int = 0; i < 10; ++i) {
				stone = new Stone();
				stone.x = Math.random() * 300;
				stone.y = Math.random() * 300;
				_gameContainer.addChild(stone);
				_stones.push(stone);
			}
		}
		
		private function removeStones():void {
			for each (var stone:Stone in _stones) {
				_gameContainer.removeChild(stone);
			}
			_stones = null;
		}
		
		private function addHunterListeners(hunter:Hunter):void {
			hunter.addEventListener(MouseEvent.CLICK, onHunterClick);
			hunter.addEventListener(KeyPointEvent.REMOVE_ME, onkeyPointRemoveRequest);
		}
		private function removeHunterListeners(hunter:Hunter):void {
			hunter.removeEventListener(MouseEvent.CLICK, onHunterClick);
			hunter.addEventListener(KeyPointEvent.REMOVE_ME, onkeyPointRemoveRequest);
		}
		
		private function addAnimalListeners(animal:Duck):void {
			animal.addEventListener(AnimalEvent.TOUCH_ACTOR, onAnimalTouchActor);
		}
		private function removeAnimalListeners(animal:Duck):void {
			animal.removeEventListener(AnimalEvent.TOUCH_ACTOR, onAnimalTouchActor);
		}
		
		private function onAnimalTouchActor(event:AnimalEvent):void {
			const touchedHunter:IcSprite = event.actor;
			for each (var hunter:Hunter in _hunters) {
				if (hunter == touchedHunter) {
					hunter.damage();
					hunter.x = Math.random() * 250 + 50;
					hunter.y = Math.random() * 150 + 50;
				}
			}
		}

		private function addListeners():void {
			_tileMap.addEventListener(MouseEvent.CLICK, onTileMapClick);
		}
		
		private function removeListeners():void {
			_tileMap.removeEventListener(MouseEvent.CLICK, onTileMapClick);
		}
		
		private function unClickAll():void {
			for each (var hunter:Hunter in _hunters) {
				hunter.filters = [];
			}
		}
		
		private function removeCurrentPathFromStage():void {
			for each (var keyPoint:KeyPoint in _selectedHunter.path.points) {
				_drawingContainer.removeChild(keyPoint);
			}
			_drawingContainer.graphics.clear();
		}
		
		private function onHunterClick(event:MouseEvent):void {
			unClickAll();
			if (_selectedHunter) { removeCurrentPathFromStage(); }
			const hunter:Hunter = findClickedHunter(event.stageX, event.stageY);
			if (hunter) {
				_drawing = true;
				_selectedHunter = hunter;
				hunter.filters = [new GlowFilter()];
				drawHunterExistingPath(_selectedHunter);
			}
		}
		
		private function onkeyPointRemoveRequest(event:KeyPointEvent):void {
			_drawingContainer.removeChild(event.keyPoint);
		}
		
		private function drawHunterExistingPath(hunter:Hunter):void {
			if (!hunter) { return; }
			_drawingContainer.graphics.lineStyle(3, 0xffaabb);
			_drawingContainer.graphics.moveTo(hunter.x + hunter.width/2,
																					hunter.y + hunter.height/2);
			if (hunter.path) {
				for each (var point:KeyPoint in hunter.path.points) {
					_drawingContainer.graphics.lineTo(point.x, point.y);
					_drawingContainer.addChild(point);
				}
			}
		}
		
		private function findClickedHunter(x:Number, y:Number):Hunter {
			for each (var hunter:Hunter in _hunters) {
				if (hunter.hitTestPoint(x, y)) { return hunter; }
			}
			return null;
		}
		
		private function addKeyPointListener(keyPoint:KeyPoint):void {
			keyPoint.addEventListener(KeyPointEvent.CLICK, onKeyPointClick);
		}
		
		private function onKeyPointClick(event:KeyPointEvent):void {
			unselectAllKeyPoints();
			event.keyPoint.select();
		}
		
		private function unselectAllKeyPoints():void {
			for each (var keyPoint:KeyPoint in _selectedHunter.path.points) {
				keyPoint.unselect();
			}
		}
		
		private function onTileMapClick(event:MouseEvent):void {
			if (_drawing) {
				if (findClickedHunter(event.stageX, event.stageY) == null) {
					_drawingContainer.graphics.lineTo(event.stageX, event.stageY);
					const point:Point = new Point(event.stageX, event.stageY);
					if (_selectedHunter) {
						_selectedHunter.addWayPoint(point);
						addKeyPoint();
					}
				}
			}
		}
		
		private function addKeyPoint():void {
			const keyPoint:KeyPoint = _selectedHunter.path.getLastKeyPoint();
			if (keyPoint) {
				_drawingContainer.addChild(keyPoint);
				addKeyPointListener(keyPoint);
			}
		}
		
	}
}
