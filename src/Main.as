package {
	import flash.system.Security;
	import game.map.tilemap.TileMap;
	import flash.events.Event;
	import game.GameScene;
	import game.MenuScene;
	import mochi.as3.MochiServices;
	import scene.SceneController;
	import flash.display.Sprite;
	
	[SWF(width=550, height=400, frameRate=25, backgroundColor=0x404040)]
	public class Main extends Sprite {
		var _mochiads_game_id:String = "21924b38e846a31e";
		public static var MOCHI_ON:Boolean = true;
		private var _tileMap:TileMap;

		public static const WIDTH:Number = 550;
		public static const HEIGHT:Number = 400;
		public static const FRAME_RATE:int = 25;
		
		public function Main() {
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			Security.allowDomain("http://www.mochiads.com/static/lib/services/");
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void {
			MochiServices.connect(_mochiads_game_id, root, onMochiConnectError);
			_tileMap = new TileMap();
			//this.alpha = .03;
			start();
		}
		
		private function start():void {
			const sceneController:SceneController = new SceneController();
			const menuScene:MenuScene = new MenuScene(this);
			const gameScene:GameScene = new GameScene(this, _tileMap);
			sceneController.addScene(menuScene, true);
			sceneController.addScene(gameScene);
			sceneController.addSceneDependence(menuScene, gameScene, true);
		}
		
		private function onMochiConnectError():void {
			trace("mochi connect fails");
			MOCHI_ON = false;
		}
		
	}
}
