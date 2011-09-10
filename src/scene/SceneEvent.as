package scene {
	import flash.events.Event;

	public class SceneEvent extends Event {
		public var sceneForOpen:IScene;
		public var scene:IScene;
		
		public static const SWITCH_ME:String = "switchMe";
		public static const CLOSE_ME:String = "closeMe";
		public static const UPDATE:String = "update";
		
		public function SceneEvent(type : String, scene : IScene, sceneForOpen:IScene = null) {
			super(type);
			this.scene = scene;
			this.sceneForOpen = sceneForOpen;
		}
	}
}
