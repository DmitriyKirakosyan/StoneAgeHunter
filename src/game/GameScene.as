package game {
	import com.bit101.components.Slider;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import scene.SceneEvent;
	import com.bit101.components.PushButton;
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
		
		private var _goBtn:PushButton;
		private var _pauseBtn:PushButton;
		private var _clearBtn:PushButton;
		private var _goMenuBtn:PushButton;
		
		private var _drawingContainer:Sprite;
		private var _drawing:Boolean;
		private var _moving:Boolean;
		private var _selectedHunter:Hunter;
		
		public function GameScene(container:Sprite, tileMap:TileMap):void {
			super();
			_mapContainer = new Sprite();
			_gameContainer = new Sprite();
			container.addChild(_mapContainer);
			container.addChild(_gameContainer);
			_gameContainer.addEventListener(Event.ENTER_FRAME, onGameContainerEnterFrame);
			_tileMap = tileMap;
			_drawingContainer = new Sprite();
		}
		
		public function open():void {
			_drawing = false;
			_moving = false;
			_mapContainer.addChild(_tileMap);
			createHunters();
			addButtons();
			_mapContainer.addChild(_drawingContainer);
			addListeners();
		}
		public function close():void {
			removeListeners();
			_mapContainer.removeChild(_tileMap);
			removeHunters();
			removeButtons();
			_mapContainer.removeChild(_drawingContainer);
		}
		
		/* Internal functions */
		
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
				hunter.remove();
			}
			_hunters = null;
		}
		
		private function addHunterListeners(hunter:Hunter):void {
			hunter.addEventListener(MouseEvent.CLICK, onHunterClick);
		}
		private function removeHunterListeners(hunter:Hunter):void {
			hunter.removeEventListener(MouseEvent.CLICK, onHunterClick);
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
		
		private function onHunterClick(event:MouseEvent):void {
			unClickAll();
			const hunter:Hunter = findClickedHunter(event.stageX, event.stageY);
			if (hunter) {
				_drawing = true;
				_selectedHunter = hunter;
				hunter.filters = [new GlowFilter()];
				drawHunterExistingPath(_selectedHunter);
			}
		}
		
		private function drawHunterExistingPath(hunter:Hunter):void {
			if (!hunter) { return; }
			_drawingContainer.graphics.lineStyle(3, 0xffaabb);
			_drawingContainer.graphics.moveTo(hunter.x + hunter.width/2,
																					hunter.y + hunter.height/2);
			if (hunter.path &&
					hunter.path.length > 0) {
				for each (var point:Point in hunter.path) {
					_drawingContainer.graphics.lineTo(point.x, point.y);
				}
			}
		}
		
		private function drawPaths():void {
			for each (var hunter:Hunter in _hunters) {
				drawHunterExistingPath(hunter);
			}
		}
		
		private function findClickedHunter(x:Number, y:Number):Hunter {
			for each (var hunter:Hunter in _hunters) {
				if (hunter.hitTestPoint(x, y)) { return hunter; }
			}
			return null;
		}
		
		private function onTileMapClick(event:MouseEvent):void {
			if (_drawing) {
				if (findClickedHunter(event.stageX, event.stageY) == null) {
					_drawingContainer.graphics.lineTo(event.stageX, event.stageY);
					addToPath(new Point(event.stageX, event.stageY));
				}
			}
		}
		
		private function addToPath(point:Point):void {
			if (_selectedHunter) {
				_selectedHunter.addWayPoint(point);
			}
		}
		
		//TODO bad memory managment here, forgot remove listeners
		private function addButtons():void {
			_goBtn = new PushButton(_gameContainer, 400, 50, "lets go", onButtonGoClick);
			_pauseBtn = new PushButton(_gameContainer, 400, 70, "pause", onButtonPauseClick);
			_clearBtn = new PushButton(_gameContainer, 400, 90, "clear", onButtonClearClick);
			_goMenuBtn = new PushButton(_gameContainer, 400, 110, "go to menu", onButtonMenuClick);
		}
		
		private function removeButtons():void {
			if (_gameContainer.contains(_goBtn)) { _gameContainer.removeChild(_goBtn); }
			if (_gameContainer.contains(_pauseBtn)) { _gameContainer.removeChild(_pauseBtn); }
			if (_gameContainer.contains(_clearBtn)) { _gameContainer.removeChild(_clearBtn); }
			if (_gameContainer.contains(_goMenuBtn)) { _gameContainer.removeChild(_goMenuBtn); }
		}
		
		private function onButtonGoClick(event:MouseEvent):void {
			_drawing = false;
			for each (var hunter:Hunter in _hunters) {
				hunter.move();
			}
			_drawingContainer.graphics.clear();
		}
		
		private function onButtonPauseClick(event:MouseEvent):void {
			for each (var hunter:Hunter in _hunters) {
				hunter.pauseMove();
			}
			drawPaths();
		}
		
		private function onButtonClearClick(event:MouseEvent):void {
			_drawingContainer.graphics.clear();
			_drawing = false;
		}
		
		private function onButtonMenuClick(event:MouseEvent):void {
			event.stopPropagation();
			dispatchEvent(new SceneEvent(SceneEvent.SWITCH_ME, this));
		}
		
	}
}
