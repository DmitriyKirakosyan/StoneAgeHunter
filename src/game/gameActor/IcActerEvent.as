package game.gameActor {
	import flash.events.Event;
	
	public class IcActerEvent extends Event {
		public var acter:IcActer;
		
		public static const TWEEN_COMPLETE:String = "tweenTick";
		public static const TWEEN_START:String = "tweenStart";
		public function IcActerEvent(type:String, icActer:IcActer) {
			super(type);
			this.acter = icActer;
		}
	}
}