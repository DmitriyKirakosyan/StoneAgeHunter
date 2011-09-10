package {
	import game.GameScene;
	import game.MenuScene;
	import scene.SceneController;
	import flash.display.Sprite;

	public class Main extends Sprite {
		public function Main() {
			const sceneController:SceneController = new SceneController();
			sceneController.addScene(new MenuScene(this));
			sceneController.addScene(new GameScene(this), true);
		}
	}
}
