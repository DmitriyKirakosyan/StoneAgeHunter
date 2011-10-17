package game.gameActor {
	import flash.events.Event;
	
	public class IcActerEvent extends Event {
		
		public static const TWEEN_TICK:String = "tweenTick";
		public function IcActerEvent(type:String) {
			super(type);
		}
	}
}