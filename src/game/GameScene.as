package game {
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
		private var _container:Sprite;
		private var _tileMap:TileMap;
		private var _hunter:Hunter;
		
		private var _goBtn:PushButton;
		private var _clearBtn:PushButton;
		private var _goMenuBtn:PushButton;
		
		private var _drawingContainer:Sprite;
		private var _drawing:Boolean;
		private var _moving:Boolean;
		private var _hunterPath:Vector.<Point>;
		
		public function GameScene(container:Sprite, tileMap:TileMap):void {
			super();
			_container = container;
			_tileMap = tileMap;
			_drawingContainer = new Sprite();
		}
		
		public function open():void {
			_drawing = false;
			_moving = false;
			_container.addChild(_tileMap);
			createHunter();
			addButtons();
			_container.addChild(_drawingContainer);
		}
		public function close():void {
			_container.removeChild(_tileMap);
			removeHunter();
			removeButtons();
			_container.removeChild(_drawingContainer);
		}
		
		/* Internal functions */
		
		private function createHunter():void {
			_hunter = new Hunter();
			_hunter.x = 50;
			_hunter.y = 50;
			_container.addChild(_hunter);
			addListeners();
		}
		
		private function removeHunter():void {
			removeListeners();
			_container.removeChild(_hunter);
			_hunter.remove();
			_hunter = null;
		}
		
		private function addListeners():void {
			_hunter.addEventListener(MouseEvent.CLICK, onHunterClick);
			_tileMap.addEventListener(MouseEvent.CLICK, onTileMapClick);
		}
		
		private function removeListeners():void {
			_hunter.removeEventListener(MouseEvent.CLICK, onHunterClick);
			_tileMap.removeEventListener(MouseEvent.CLICK, onTileMapClick);
		}
		
		private function onHunterClick(event:MouseEvent):void {
			if (_moving) { return; }
			
			_drawing = true;
			
			_drawingContainer.graphics.lineStyle(3, 0xffaabb);
			_drawingContainer.graphics.moveTo(event.stageX, event.stageY);
		}
		
		private function onTileMapClick(event:MouseEvent):void {
			if (_drawing) {
				if (!_hunter.hitTestPoint(event.stageX, event.stageY)) {
					_drawingContainer.graphics.lineTo(event.stageX, event.stageY);
					addToPath(new Point(event.stageX, event.stageY));
				}
			}
		}
		
		private function addToPath(point:Point):void {
			if (!_hunterPath) { _hunterPath = new Vector.<Point>(); }
			_hunterPath.push(point);
		}
		
		//TODO bad memory managment here, forgot remove listeners
		private function addButtons():void {
			_goBtn = new PushButton(_container, 300, 50, "lets go", onButtonGoClick);
			_clearBtn = new PushButton(_container, 300, 70, "clear", onButtonClearClick);
			_goMenuBtn = new PushButton(_container, 300, 90, "go to menu", onButtonMenuClick);
		}
		
		private function removeButtons():void {
			if (_container.contains(_goBtn)) { _container.removeChild(_goBtn); }
			if (_container.contains(_clearBtn)) { _container.removeChild(_clearBtn); }
			if (_container.contains(_goMenuBtn)) { _container.removeChild(_goMenuBtn); }
		}
		
		private function onButtonGoClick(event:MouseEvent):void {
			if (_moving) { return; }
			_drawing = false;
			_hunter.followPath(_hunterPath);
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
