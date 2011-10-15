package game {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class DrawingController {
		private var _parentContainer:Sprite;
		private var _drawingContainer:Sprite;
		private var _drawing:Boolean;
		private var _pathParts:Vector.<Sprite>;
		
		private var _currentX:Number;
		private var _currentY:Number;
		
		public function DrawingController(container:Sprite) {
			super();
			_parentContainer = container;
			_drawingContainer = new Sprite();
			_parentContainer.addChild(_drawingContainer);
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
		
		private function onEnterFrame(event:Event):void {
			drawPathToCurrentPoint();	
		}
		
		private function drawPathToCurrentPoint():void {
			if (!_drawing || !needDrawLine()) { return; }
			var lastPoint:Point = (_pathParts && _pathParts.length > 0) ?
											new Point(_pathParts[_pathParts.length-1].x, _pathParts[_pathParts.length-1].y) :
											null;
			var newPathPart:Sprite;
			if (!lastPoint) {
				newPathPart = createPathPart();
				_drawingContainer.addChild(newPathPart);
				addPathPartToVector(newPathPart);
			} else {
				var nowPoint:Point = new Point(_currentX, _currentY);
				var lineLength:Number = Point.distance(lastPoint, nowPoint);
				for (var i:int = 6; i < lineLength; i+= 6) {
					newPathPart = createPathPart( Point.interpolate(nowPoint, lastPoint, i / lineLength) );
					_drawingContainer.addChild(newPathPart);
					addPathPartToVector(newPathPart);
				}
			}
		}
		
		private function needDrawLine():Boolean {
			if (_pathParts && _pathParts.length > 0) {
				if ( (_pathParts[_pathParts.length-1].x - _currentX < 6 &&
					_pathParts[_pathParts.length-1].x - _currentX > -6) &&
					(_pathParts[_pathParts.length-1].y - _currentY < 6 &&
						_pathParts[_pathParts.length-1].y - _currentY > -6) ) {
							return false;
						}
			}
			return true;
		}
		
		private function onMouseMove(event:MouseEvent):void {
			if (_drawing) {
				_currentX = event.stageX;
				_currentY = event.stageY;
			}
		}
		
		private function onMouseDown(event:MouseEvent):void {
			_drawing = true;
			_currentX = event.stageX;
			_currentY = event.stageY;
			_parentContainer.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onMouseUp(event:MouseEvent):void {
			_parentContainer.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			_drawing = false;
			removeAllPathParts();
		}
		
		private function removeAllPathParts():void {
			for each (var part:Sprite in _pathParts) { _drawingContainer.removeChild(part); }
			_pathParts = null
		}
		
		private function addPathPartToVector(pathPart:Sprite):void {
			if (!_pathParts) { _pathParts = new Vector.<Sprite>(); }
			_pathParts.push(pathPart);
		}
		
		private function createPathPart(point:Point = null):Sprite {
			var result:Sprite = new Sprite();
			result.graphics.beginFill(0xffffff);
			result.graphics.drawCircle(0, 0, 2);
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