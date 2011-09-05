package {
	import org.flixel.FlxGame;
	import game.GameController;

	[SWF(width="640", height="480")]
	[Frame(factoryClass="Preloader")]

	public class Main extends FlxGame {
		
		
		public function Main() {
			super(640, 480, MenuState, 1, 60, 30, true);
			LayerManager.init(this);
			//new GameController(LayerManager.getLayer(LayerManager.GAME));
		}
	}
}
