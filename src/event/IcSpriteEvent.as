package event
{
	import animation.IcSprite;
	
	import flash.events.Event;
	
	public class IcSpriteEvent extends Event
	{
		
		public static const MOVE:String = "move";
		
		public var icTarget:IcSprite;
		
		public function IcSpriteEvent(type:String, _target:*, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			icTarget = _target;
			super(type, bubbles, cancelable);
		}
	}
}