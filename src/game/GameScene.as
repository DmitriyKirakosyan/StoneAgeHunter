package game {
	import tilemap.TileMap;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import scene.IScene;

	public class GameScene extends EventDispatcher implements IScene {
		private var _container:Sprite;
		private var _tileMap:TileMap;
		
		public function GameScene(container:Sprite, tileMap:TileMap):void {
			super();
			_container = container;
			_tileMap = tileMap;
		}
		
		public function open():void {
			_container.addChild(_tileMap);
		}
		public function close():void {
			_container.removeChild(_tileMap);
		}
	}
}
