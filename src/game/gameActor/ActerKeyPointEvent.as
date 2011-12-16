package game.gameActor {
	import flash.events.Event;

import game.gameActor.IcActor;

public class ActerKeyPointEvent extends Event {
		public var keyPoint:KeyPoint;
		public var acter:IcActor;
		
		public static const CLICK:String = "keyPointClick";
		public static const REMOVE_ME:String = "removeMe";
		public function ActerKeyPointEvent(type : String, acter:IcActor, keyPoint:KeyPoint) {
			super(type);
			this.keyPoint = keyPoint;
			this.acter = acter;
		}
	}
}
