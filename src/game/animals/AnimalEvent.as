package game.animals {
	import animation.IcSprite;
	import flash.events.Event;

	public class AnimalEvent extends Event {
		public var actor:IcSprite;
		
		public static const TOUCH_ACTOR:String = "touchActor";
		public static const FOLLOW_COMPLETE:String = "followComplete";
		public function AnimalEvent(type : String, actor:IcSprite) {
			super(type);
			this.actor = actor;
		}
	}
}
