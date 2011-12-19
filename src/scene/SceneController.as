package scene {
	import flash.events.EventDispatcher;

	public class SceneController extends EventDispatcher {
		
		private var _sceneList:Vector.<IScene>;
		
		private var _sceneDepending:Vector.<SceneDependence>;
		
		private var _currentScene:IScene;
		
		public function SceneController() {
			super();
			_sceneList = new Vector.<IScene>();
			_sceneDepending = new Vector.<SceneDependence>();
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
		
		public function addSceneDependence(from:IScene, to:IScene, bilateral:Boolean = false):void {
			_sceneDepending.push(new SceneDependence(from, to, bilateral));
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
		
		// events handlers
		
		private function onSceneWantSwitch(event:SceneEvent):void {
			event.targetScene.close();
			if (event.sceneForOpen) {
				event.sceneForOpen.open();
				_currentScene = event.sceneForOpen;
			} else {
				var depScene:IScene = findDependenceSceneFor(event.targetScene);
				if (depScene) {
					depScene.open();
					_currentScene = depScene;
				}
			}
		}
		
		private function findDependenceSceneFor(scn:IScene):IScene {
			for each (var sceneDependence:SceneDependence in _sceneDepending) {
				if (sceneDependence.sceneFrom == scn) {
					return sceneDependence.sceneTo;
				} else if (sceneDependence.sceneTo == scn &&
										sceneDependence.bilateral) {
					return sceneDependence.sceneFrom;
										}
			}
			return null;
		}
	}
}
