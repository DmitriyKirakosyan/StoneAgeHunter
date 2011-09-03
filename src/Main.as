package {
	import flash.display.Sprite;
	import game.GameController;

	public class Main extends Sprite {
		
		
		public function Main() {
			LayerManager.init(this);
			new GameController(LayerManager.getLayer(LayerManager.GAME));
			
		}
	}
}
