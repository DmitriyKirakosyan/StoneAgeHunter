package game.gameActor {
	import flash.events.Event;

	public class KeyPointEvent extends Event {
		public var keyPoint:KeyPoint;
		
		public static const CLICK:String = "keyPointClick";
		public static const REMOVE_ME:String = "removeMe";
		public function KeyPointEvent(type : String, keyPoint:KeyPoint) {
			super(type);
			this.keyPoint = keyPoint;
		}
	}
}
