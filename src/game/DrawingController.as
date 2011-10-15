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
				var newPathPart:Sprite = createPathPart();
				_drawingContainer.addChild(newPathPart);
				addPathPartToVector(newPathPart);
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
				result.x = point.y;
				result.y = point.y;
			} else {
				result.x = _currentX;
				result.y = _currentY;
			}
			return result;
		}
		
	}
}