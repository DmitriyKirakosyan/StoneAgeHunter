package events {
	import game.hunters.Hunter;
	import flash.events.Event;

	public class HunterEvent extends Event {
		public var hunter:Hunter;
		
		public static const CLICK:String = "hunterClick";
		public function HunterEvent(type : String, hunter:Hunter = null) {
			super(type);
			this.hunter = hunter;
		}
	}
}
