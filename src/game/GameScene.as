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
	import game.gameActor.KeyPoint;
	import game.gameActor.KeyPointEvent;
	import game.gameActor.LinkToPoint;

	public class GameScene extends EventDispatcher implements IScene {
		private var _mapContainer:Sprite;
		private var _gameContainer:Sprite;
		private var _tileMap:TileMap;
		private var _hunters:Vector.<Hunter>;
		private var _duck:Duck;
		private var _stonesController:StonesController;
		
		private var _debugPanel:DebugPanel;
		
		private var _drawingContainer:Sprite;
		private var _drawing:Boolean;
		private var _moving:Boolean;
		private var _selectedHunter:Hunter;
		
		private var _dreamChanger:DreamChanger;
		
		public function GameScene(container:Sprite, tileMap:TileMap):void {
			super();
			_mapContainer = new Sprite();
			_gameContainer = new Sprite();
			_stonesController = new StonesController(_gameContainer);
			_debugPanel = new DebugPanel(container, this);
			container.addChild(_mapContainer);
			container.addChild(_gameContainer);
			_gameContainer.addEventListener(Event.ENTER_FRAME, onGameContainerEnterFrame);
			_tileMap = tileMap;
			_drawingContainer = new Sprite();
			_dreamChanger = new DreamChanger(this, container);
		}
		
		/* functions for debug */
		
		public function dreamModeOn():void {
			_dreamChanger.dreamOn();
		}
		
		public function dreamModeOff():void {
			_dreamChanger.dreamOff();
		}
		
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
		public function get gameContainer():Sprite {
			return _gameContainer;
		}
		public function get mapContainer():Sprite {
			return _mapContainer;
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
			_stonesController.createStones();
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
			_stonesController.removeStones();
			_mapContainer.removeChild(_drawingContainer);
			_drawingContainer.graphics.clear();
		}
		
		public function getDreamingObjects():Vector.<Sprite> {
			const result:Vector.<Sprite> = new Vector.<Sprite>();
			for each (var hunter:Hunter in _hunters) { result.push(hunter); }
			result.push(_duck);
			
			return result;
		}
		
		public function get tileMap():TileMap { return _tileMap; }
		
		public function play():void {
			_drawing = false;
			unClickAll();
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
		
		private function createHunter(debug:Boolean):Hunter {
			const hunter:Hunter = new Hunter(debug);
			hunter.x = Math.random() * 250 + 50;
			hunter.y = Math.random() * 150 + 50;
			_gameContainer.addChild(hunter);
			addHunterListeners(hunter);
			return hunter;
		}
		
		private function createHunters():void {
			_hunters = new Vector.<Hunter>();
			var hunter:Hunter;
			for (var i:int = 0; i < 2; ++i) {
				hunter = createHunter(false);
				_hunters.push(hunter);
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
			animal.addEventListener(MouseEvent.CLICK, onAnimalClick);
			animal.addEventListener(MouseEvent.MOUSE_OVER, onAnimalMouseOver);
			animal.addEventListener(MouseEvent.MOUSE_OUT, onAnimalMouseOut);
		}
		private function removeAnimalListeners(animal:Duck):void {
			animal.removeEventListener(AnimalEvent.TOUCH_ACTOR, onAnimalTouchActor);
			animal.removeEventListener(MouseEvent.CLICK, onAnimalClick);
			animal.removeEventListener(MouseEvent.MOUSE_OVER, onAnimalMouseOver);
			animal.removeEventListener(MouseEvent.MOUSE_OUT, onAnimalMouseOut);
		}
		
		private function onAnimalTouchActor(event:AnimalEvent):void {
			const touchedHunter:IcSprite = event.actor;
			for each (var hunter:Hunter in _hunters) {
				if (hunter == touchedHunter) {
					hunter.damage();
//					hunter.x = Math.random() * 250 + 50;
//					hunter.y = Math.random() * 150 + 50;
				}
			}
		}
		
		private function onAnimalClick(event:MouseEvent):void {
			if (_selectedHunter && _selectedHunter.path) {
				_selectedHunter.path.setAttackPoint();
			}
		}
		
		private function onAnimalMouseOver(event:MouseEvent):void {
			if (_selectedHunter && _selectedHunter.path) {
				_duck.mouseOver();
			}
		}
		private function onAnimalMouseOut(event:MouseEvent):void {
			_duck.mouseOut();
		}

		private function addListeners():void {
			_tileMap.addEventListener(MouseEvent.CLICK, onTileMapClick);
		}
		
		private function removeListeners():void {
			_tileMap.removeEventListener(MouseEvent.CLICK, onTileMapClick);
		}
		
		private function unClickAll():void {
			for each (var hunter:Hunter in _hunters) {
				hunter.unselect();
			}
		}
		
		private function onHunterClick(event:MouseEvent):void {
			unClickAll();
			if (_selectedHunter) { hideCurrentPath(); }
			const hunter:Hunter = findClickedHunter(event.stageX, event.stageY);
			if (hunter) {
				_drawing = true;
				_selectedHunter = hunter;
				hunter.onClick();
				showHunterExistingPath(_selectedHunter);
			}
		}
		
		private function onkeyPointRemoveRequest(event:KeyPointEvent):void {
			if (_drawingContainer.contains(event.keyPoint)) {
				_drawingContainer.removeChild(event.keyPoint);
			} else {
				trace("[GameScene.onkeyPointRemoveRequest] WARNING keyPoint dont contants on scene");
			}
		}
		
		private function showHunterExistingPath(hunter:Hunter):void {
			if (!hunter) { return; }
			if (hunter.path) {
				for each (var point:KeyPoint in hunter.path.points) {
					point.alpha = 1;
				}
			}
			if (hunter.path.links) { hunter.path.links.forEach(function(item:LinkToPoint, ..._):void { item.alpha = 1; }); }
		}
		
		private function hideCurrentPath():void {
			if (!_selectedHunter.path) { return; }
			for each (var keyPoint:KeyPoint in _selectedHunter.path.points) {
				keyPoint.alpha = .4;
			}
			if (_selectedHunter.path.links) { _selectedHunter.path.links.forEach(function(item:LinkToPoint, ..._):void { item.alpha = .4; }); }
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
			const link:LinkToPoint = _selectedHunter.path.getLastLinkToPoint();
			if (keyPoint) {
				_drawingContainer.addChild(keyPoint);
				if (link) { _drawingContainer.addChild(link); }
				addKeyPointListener(keyPoint);
			}
		}
		
	}
}
