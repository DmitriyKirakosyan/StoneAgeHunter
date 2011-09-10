package scene {
	import flash.events.IEventDispatcher;
	public interface IScene extends IEventDispatcher{
		function open():void;
		function close():void;
	}
}
