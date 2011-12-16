package game {
	import animation.IcSprite;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import game.animals.AnimalEvent;
	import game.animals.Duck;
	import game.armor.Stone;
import game.debug.DebugConsole;
import game.debug.DebugPanel;
import game.gameActor.IcActerEvent;
	import game.gameActor.KeyPoint;
	import game.gameActor.ActerKeyPointEvent;
	import game.gameActor.LinkToPoint;
	import game.player.Hunter;
	
	import scene.IScene;
	import scene.SceneEvent;
	
	import tilemap.TileMap;

	public class GameScene extends EventDispatcher implements IScene {
		private var _mapContainer:Sprite;
		private var _gameContainer:Sprite;
		private var _tileMap:TileMap;
		private var _hunters:Vector.<Hunter>;
		private var _drawingController:DrawingController;
		private var _zSortingManager:ZSortingManager;
		
		private var _debugPanel:DebugPanel;
		private var _debugConsole:DebugConsole;
		
		private var _drawingContainer:Sprite;
		private var _drawing:Boolean;
		private var _selectedHunter:Hunter;
		
		public function GameScene(container:Sprite, tileMap:TileMap):void {
			super();
			_mapContainer = new Sprite();
			_gameContainer = new Sprite();
			_debugPanel = new DebugPanel(container, this);
			_debugConsole = new DebugConsole(this);
			_zSortingManager = new ZSortingManager(this);
			container.addChild(_mapContainer);
			_drawingController = new DrawingController(container, tileMap);
			container.addChild(_gameContainer);
			_gameContainer.addEventListener(Event.ENTER_FRAME, onGameContainerEnterFrame);
			_tileMap = tileMap;
			_drawingContainer = new Sprite();
		}
		
		/* functions for debug */
		
		public function get drawingController():DrawingController { return _drawingController; }

		public function get gameContainer():Sprite { return _gameContainer; }
		
		public function get hunters():Vector.<Hunter> {
			return _hunters;
		}
		
		public function get mapContainer():Sprite {
			return _mapContainer;
		}
		
		public function dispatchAboutClose():void {
			dispatchEvent(new SceneEvent(SceneEvent.SWITCH_ME, this));
		}
		
		public function open():void {
			_drawing = false;
			_mapContainer.addChild(_tileMap);
			createHunters();
			_drawingController.addHunters(_hunters);
			addDrawingControllerListeners();
			_mapContainer.addChild(_drawingContainer);
			addListeners();
			_debugPanel.open();
			_debugConsole.init();
		}
		public function close():void {
			_debugConsole.remove();
			_debugPanel.close();
			removeListeners();
			_mapContainer.removeChild(_tileMap);
			removeHunters();
			_mapContainer.removeChild(_drawingContainer);
			_drawingContainer.graphics.clear();
			removeDrawingControllerListeners();
		}
		
		/* Internal functions */
		
		private function onGameContainerEnterFrame(event:Event):void {
			_zSortingManager.checkZSorting();
		}
		
		private function createHunter(debug:Boolean):Hunter {
			const hunter:Hunter = new Hunter(debug);
			_gameContainer.addChild(hunter);
			addHunterListeners(hunter);
			return hunter;
		}
		
		private function createHunters():void {
			_hunters = new Vector.<Hunter>();
			var hunter:Hunter;
			for (var i:int = 0; i < 2; ++i) {
				hunter = createHunter(false);
				hunter.x = 350 + i * 80; hunter.y = 300 - i * 30;
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

		private function addDrawingControllerListeners():void {
			_drawingController.addEventListener(DrawingControllerEvent.START_DRAWING_PATH, onStartDrawingPath);
		}
		
		private function removeDrawingControllerListeners():void {
			_drawingController.removeEventListener(DrawingControllerEvent.START_DRAWING_PATH, onStartDrawingPath);
		}
		
		private function addHunterListeners(hunter:Hunter):void {
			hunter.addEventListener(MouseEvent.CLICK, onHunterClick);
			hunter.addEventListener(ActerKeyPointEvent.REMOVE_ME, onkeyPointRemoveRequest);
		}
		private function removeHunterListeners(hunter:Hunter):void {
			hunter.removeEventListener(MouseEvent.CLICK, onHunterClick);
			hunter.removeEventListener(ActerKeyPointEvent.REMOVE_ME, onkeyPointRemoveRequest);
		}
		
		private function onStartDrawingPath(event:DrawingControllerEvent):void {
			if (_drawingController.selectedHunter) {
				_drawingController.selectedHunter.startFollowPath();
			}
		}
		
		private function onAnimalTouchActor(event:AnimalEvent):void {
			const touchedHunter:IcSprite = event.actor;
			for each (var hunter:Hunter in _hunters) {
				if (hunter == touchedHunter) {
					hunter.damage();
				}
			}
		}
		
		private function onAnimalClick(event:MouseEvent):void {
			if (_selectedHunter && _selectedHunter.path) {
				_selectedHunter.path.setAttackPoint();
			}
		}
		
		private function addListeners():void {
			_drawingController.addListeners();
		}
		
		private function removeListeners():void {
			_drawingController.removeListeners();
		}
		
		private function unClickAll():void {
			for each (var hunter:Hunter in _hunters) {
			}
		}
		
		private function onHunterClick(event:MouseEvent):void {
			unClickAll();
			if (_selectedHunter) { hideCurrentPath(); }
			const hunter:Hunter = findClickedHunter(event.stageX, event.stageY);
			if (hunter) {
				_drawing = true;
				_selectedHunter = hunter;
				showHunterExistingPath(_selectedHunter);
			}
		}
		
		private function onkeyPointRemoveRequest(event:ActerKeyPointEvent):void {
			if (!(event.acter is Hunter)) { trace("[GameScene.onkeyPointRemoveRequest] acter isnt hunter"); return; }
			_drawingController.removePoint(event.acter as Hunter,  event.keyPoint.point);
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
		
	}
}
