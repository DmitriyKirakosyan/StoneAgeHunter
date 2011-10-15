package game {
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class DrawingController {
		private var _parentContainer:Sprite;
		
		public function DrawingController(container:Sprite) {
			super();
			_parentContainer = container;
		}
		
		public function addListeners():void {
			_parentContainer.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_parentContainer.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		public function removeListeners():void {
			_parentContainer.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_parentContainer.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		/* Internal functions */
		
		private function onMouseDown(event:MouseEvent):void {
			
		}
		
		private function onMouseUp(event:MouseEvent):void {
			
		}
	}
}