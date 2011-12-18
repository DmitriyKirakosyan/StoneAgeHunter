package event
{
	import animation.IcSprite;
	
	import flash.events.Event;
	
	public class IcSpriteEvent extends Event
	{
		
		public static const MOVE_BY_Y:String = "move_by_y";
		public static const MOVE_BY_X:String = "move_by_x";
		
		public var icTarget:IcSprite;
		
		public function IcSpriteEvent(type:String, _target:*, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			icTarget = _target;
			super(type, bubbles, cancelable);
		}
	}
}