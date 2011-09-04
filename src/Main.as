package {
	import org.flixel.FlxGame;
	import game.GameController;

	[SWF(width="640", height="480", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]

	public class Main extends FlxGame {
		
		
		public function Main() {
			super(320, 240, MenuState, 2, 60, 30, true);
			LayerManager.init(this);
			//new GameController(LayerManager.getLayer(LayerManager.GAME));
		}
	}
}
