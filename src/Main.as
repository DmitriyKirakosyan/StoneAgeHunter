package {
	import tilemap.TileMap;
	import flash.events.Event;
	import game.GameScene;
	import game.MenuScene;
	import scene.SceneController;
	import flash.display.Sprite;

	public class Main extends Sprite {
		public function Main() {
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void {
			const tileMap:TileMap = new TileMap("PrototypeTexture");

			const sceneController:SceneController = new SceneController();
			sceneController.addScene(new MenuScene(this));
			sceneController.addScene(new GameScene(this, tileMap), true);

		}

	}
}
