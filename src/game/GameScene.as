package game {
	import game.player.Hunter;
	import tilemap.TileMap;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import scene.IScene;

	public class GameScene extends EventDispatcher implements IScene {
		private var _container:Sprite;
		private var _tileMap:TileMap;
		private var _hunter:Hunter;
		
		public function GameScene(container:Sprite, tileMap:TileMap):void {
			super();
			_container = container;
			_tileMap = tileMap;
		}
		
		public function open():void {
			_container.addChild(_tileMap);
			createHunter();
		}
		public function close():void {
			_container.removeChild(_tileMap);
			removeHunter();
		}
		
		/* Internal functions */
		
		private function createHunter():void {
			_hunter = new Hunter();
			_hunter.x = 50;
			_hunter.y = 50;
			_container.addChild(_hunter);
		}
		
		private function removeHunter():void {
			_container.removeChild(_hunter);
			_hunter.remove();
			_hunter = null;
		}
	}
}
