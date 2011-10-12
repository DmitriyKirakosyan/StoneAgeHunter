package game {
	import flash.display.Sprite;
	
	import game.armor.Stone;

	public class StonesController {
		
		private var _stones:Vector.<Stone>;
		private var _gameContainer:Sprite;
		
		public function StonesController(gameContainer:Sprite) {
			super();
			_gameContainer = gameContainer;
		}
		
		public function createStones():void {
			var stone:Stone;
			_stones = new Vector.<Stone>();
			for (var i:int = 0; i < 10; ++i) {
				stone = new Stone();
				stone.x = Math.random() * 300;
				stone.y = Math.random() * 300;
				_gameContainer.addChild(stone);
				_stones.push(stone);
			}
		}
		
		public function removeStones():void {
			for each (var stone:Stone in _stones) {
				_gameContainer.removeChild(stone);
			}
			_stones = null;
		}
		
	}
}