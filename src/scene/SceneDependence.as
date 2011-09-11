package scene {
	public class SceneDependence {
		public var sceneFrom:IScene;
		public var sceneTo:IScene;
		public var bilateral:Boolean;
		
		public function SceneDependence(from:IScene, to:IScene, bilateral:Boolean = false):void {
			sceneFrom = from;
			sceneTo = to;
			this.bilateral = bilateral;
		}
	}
}
