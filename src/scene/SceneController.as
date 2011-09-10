package scene {
	import flash.events.EventDispatcher;

	public class SceneController extends EventDispatcher {
		
		private var _sceneList:Vector.<IScene>;
		
		private var _currentScene:IScene;
		
		public function SceneController() {
			super();
			_sceneList = new Vector.<IScene>();
		}
		
		/* API */
		
		public function addScene(scn:IScene, andOpen:Boolean = false):void {
			if (_sceneList.indexOf(scn) == -1) {
				_sceneList.push(scn);
				addListenersFor(scn);
			}
			if (andOpen) {
				openScene(scn);
			}
		}
		
		public function openScene(scn:IScene):void {
			if (_currentScene) {
				_currentScene.close();
			}
			scn.open();
			_currentScene = scn;
		}
		
		/* Internal functions */
		
		private function addListenersFor(scn:IScene):void {
			scn.addEventListener(SceneEvent.SWITCH_ME, onSceneWantSwitch);
		}
		
		// event handlers
		
		private function onSceneWantSwitch(event:SceneEvent):void {
			event.targetScene.close();
			event.sceneForOpen.open();
			_currentScene = event.sceneForOpen;
		}
	}
}
