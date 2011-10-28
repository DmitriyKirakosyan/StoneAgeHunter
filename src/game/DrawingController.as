package game {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import game.player.Hunter;
	
	import tilemap.TileMap;

	public class DrawingController extends EventDispatcher{
		private var _parentContainer:Sprite;
		private var _drawingContainer:Sprite;
		private var _drawing:Boolean;

		private var _selectedHunter:Hunter;
		
		private var _hunters:Vector.<Hunter>;
		
		private var _currentX:Number;
		private var _currentY:Number;
		
		private var _partsDistance:Number;
		private var _partShape:String;
		
		private var _tilemap:TileMap;
		
		public static const SHAPE_RECTANGLE:String = "rectangle";
		
		public function DrawingController(container:Sprite, tilemap:TileMap) {
			super();
			_partsDistance = 2;
			_parentContainer = container;
			_tilemap = tilemap;
			_drawingContainer = new Sprite();
			_parentContainer.addChild(_drawingContainer);
		}
		
		public function setPathPartsDistance(value:Number):void {
			_partsDistance = value;
		}
		
		public function setPartShape(shapeName:String):void {
			_partShape = shapeName;
		}
		
		public function removePoint(point:Point):void {
			var pathParts:Vector.<Sprite> = _selectedHunter.pathParts;
			if (!pathParts) { return; }
			for (var i:int = 0; i < pathParts.length; ++i) {
				if (pathParts[i].x == point.x && pathParts[i].y == point.y) {
					removeFirstPoints(pathParts,  i+1);
				}
			}
		}


		public function get selectedHunter():Hunter { return _selectedHunter; }
		
		public function addHunter(hunter:Hunter):void {
			if (!_hunters) { _hunters = new Vector.<Hunter>(); }
			_hunters.push(hunter);
		}
		
		public function addHunters(hunters:Vector.<Hunter>):void {
			if (!_hunters) { _hunters = new Vector.<Hunter>(); }
			if (hunters) {
				hunters.forEach(function(item:Hunter, ..._):void { _hunters.push(item); });
			}
		}
		
		public function addListeners():void {
			_parentContainer.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_parentContainer.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_parentContainer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		public function removeListeners():void {
			_parentContainer.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_parentContainer.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_parentContainer.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_parentContainer.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		/* Internal functions */
		
		private function removeFirstPoints(pathParts:Vector.<Sprite>, num:int):void {
			for (var i:int = 0; i < num; ++i) {
				if (_drawingContainer.contains(pathParts[i])) {
					_drawingContainer.removeChild(pathParts[i]);
				} else { trace(" WARN [DrawingController.removePoint] pathPart dosnt contains on drawingContainer"); }
			}
			pathParts.splice(0, num);
		}

		private function onEnterFrame(event:Event):void {
			if (_tilemap.canGoTo(new Point(_currentX, _currentY)) &&
					(!_selectedHunter.pathParts || _selectedHunter.pathParts.length < 250)) {
				drawPathToCurrentPoint();
			} else {
				stopDrawing();
			}
		}
		
		private function drawPathToCurrentPoint():void {
			if (!_drawing || !_selectedHunter || !needDrawLine()) { return; }
			var lastPoint:Point = (_selectedHunter.pathParts && _selectedHunter.pathParts.length > 0) ?
											new Point(_selectedHunter.pathParts[_selectedHunter.pathParts.length-1].x,
																_selectedHunter.pathParts[_selectedHunter.pathParts.length-1].y) :
											null;
			var newPathPart:Sprite;
			if (!lastPoint) {
				newPathPart = createPathPart();
				addNewPathPart(newPathPart);
			} else {
				var nowPoint:Point = new Point(_currentX, _currentY);
				var lineLength:Number = Point.distance(lastPoint, nowPoint);
				for (var i:int = 4 + _partsDistance; i < lineLength; i+= 4 + _partsDistance) {
					newPathPart = createPathPart( Point.interpolate(nowPoint, lastPoint, i / lineLength) );
					addNewPathPart(newPathPart);
				}
			}
		}
		
		private function addNewPathPart(pathPart:Sprite):void {
			_drawingContainer.addChild(pathPart);
			_selectedHunter.addPathPart(pathPart);
		}
		
		private function needDrawLine():Boolean {
			return _selectedHunter.needDrawLine(_currentX, _currentY);
		}
		
		private function onMouseMove(event:MouseEvent):void {
			if (_drawing) {
				_currentX = event.stageX;
				_currentY = event.stageY;
			}
		}
		
		private function onMouseDown(event:MouseEvent):void {
			var selectedHunter:Hunter = findSelectedHunter(event.stageX, event.stageY);
			if (selectedHunter) {
				removePathPartsOf(selectedHunter);
				_selectedHunter = selectedHunter;
				_drawing = true;
				_currentX = event.stageX;
				_currentY = event.stageY;
				_parentContainer.addEventListener(Event.ENTER_FRAME, onEnterFrame);
				dispatchEvent(new DrawingControllerEvent(DrawingControllerEvent.START_DRAWING_PATH, new Point(event.stageX, event.stageY)));
			}
		}
		
		private function findSelectedHunter(mouseX:Number, mouseY:Number):Hunter {
			for each (var hunter:Hunter in _hunters) {
				if (hunter.hitTestPoint(mouseX, mouseY)) {
					return hunter;
				}
			}
			return null;
		}
		
		private function onMouseUp(event:MouseEvent):void {
			stopDrawing();
		}
		
		private function stopDrawing():void {
			_parentContainer.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			_drawing = false;
		}
		
		private function removePathPartsOf(hunter:Hunter):void {
			for each (var pathPart:Sprite in hunter.pathParts) {
				if (_drawingContainer.contains(pathPart)) { _drawingContainer.removeChild(pathPart); }
			}
		}
		
		private function createPathPart(point:Point = null):Sprite {
			var result:Sprite = new Sprite();
			result.graphics.beginFill(_selectedHunter ? _selectedHunter.baseColor : 0xffffff);
			if (_partShape == SHAPE_RECTANGLE) {
				result.graphics.drawRect(-3, -3, 6, 6);
			} else { result.graphics.drawCircle(0, 0, 2); }
			result.graphics.endFill();
			if (point) {
				result.x = point.x;
				result.y = point.y;
			} else {
				result.x = _currentX;
				result.y = _currentY;
			}
			return result;
		}
		
	}
}