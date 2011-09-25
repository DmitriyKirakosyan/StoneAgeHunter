package {
	import tilemap.TextureHolderEvent;
	import ru.beenza.framework.utils.EventJoin;
	import tilemap.SharedBitmapHolder;
	import tilemap.TileMap;
	import flash.events.Event;
	import game.GameScene;
	import game.MenuScene;
	import scene.SceneController;
	import flash.display.Sprite;

	public class Main extends Sprite {
		private var _tileMap:TileMap;
		
		public function Main() {
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void {
			_tileMap = new TileMap("tiles/texture");
			onActersLoaded();
			const eventJoin:EventJoin = new EventJoin(4, onActersLoaded);
			SharedBitmapHolder.instance.addEventListener(TextureHolderEvent.TEXTURE_LOADED, eventJoin.join);
			SharedBitmapHolder.load("animations/walk/walk");
			SharedBitmapHolder.load("animations/stay/breathe");
			SharedBitmapHolder.load("animations/stay/head_rotate");
			SharedBitmapHolder.load("animations/stay/butt_scratch");
		}
		
		private function onActersLoaded():void {
			const sceneController:SceneController = new SceneController();
			const menuScene:MenuScene = new MenuScene(this);
			const gameScene:GameScene = new GameScene(this, _tileMap);
			sceneController.addScene(menuScene, true);
			sceneController.addScene(gameScene);
			sceneController.addSceneDependence(menuScene, gameScene, true);
		}

	}
}
