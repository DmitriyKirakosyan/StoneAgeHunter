package game {
	import flash.events.Event;
	import flash.geom.Point;
	
	public class DrawingControllerEvent extends Event {
		public var point:Point
		
		public static const ADD_PATH_POINT:String = "addPathPoint";
		public static const START_DRAWING_PATH:String = "startDrawingPath";
		
		public function DrawingControllerEvent(type:String, point:Point) {
			super(type);
			this.point = point;
		}
	}
}