package scene {
	import flash.events.EventDispatcher;

	public class SceneController extends EventDispatcher {
		
		private var _sceneList:Vector.<IScene>;
		
		public function SceneController() {
			super();
			_sceneList = new Vector.<IScene>();
		}
		
		/* API */
		
		public function addScene(scene:IScene):void {
			if (_sceneList.indexOf(scene) == -1) {
				_sceneList.push(scene);
				addListenersFor(scene);
			}
		}
		
		/* Internal functions */
		
		private function addListenersFor(scene:IScene):void {
			scene.addEventListener(SceneEvent.SWITCH_ME, onSceneWantSwitch);
		}
		
		// event handlers
		
		private function onSceneWantSwitch(event:SceneEvent):void {
			event.scene.close();
			event.sceneForOpen.open();
		}
	}
}
