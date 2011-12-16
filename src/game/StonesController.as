package game {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import game.armor.Stone;
	import game.gameActor.IcActor;

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
				addStoneListeners(stone);
				stone.x = Math.random() * 57 + 80;
				stone.y = Math.random() * 50 + 80;
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
		
		public function getStoneUnderHunter(hunter:IcActor):Stone {
			for each (var stone:Stone in _stones) {
				if (stone.hitTestObject(hunter)) { return stone; }
			}
			return null;
		}
		
		public function removeStone(stone:Stone):void {
			var index:int = _stones.indexOf(stone);
			if (index != -1) {
				_stones.splice(index, 1);
				if (_gameContainer.contains(stone)) { _gameContainer.removeChild(stone); } else { trace("StonesController.removeStone] WARN wrong stone"); }
			}
		}
		
		/* Internal functions */
		
		private function addStoneListeners(stone:Stone):void {
			stone.addEventListener(MouseEvent.CLICK, onStoneClick);
			stone.addEventListener(MouseEvent.MOUSE_OVER, onStoneMouseOver);
			stone.addEventListener(MouseEvent.MOUSE_OUT, onStoneMouseOut);
		}
/*		private function removeStoneListeners(stone:Stone):void {
			stone.removeEventListener(MouseEvent.CLICK, onStoneClick);
			stone.removeEventListener(MouseEvent.MOUSE_OVER, onStoneMouseOver);
			stone.removeEventListener(MouseEvent.MOUSE_OUT, onStoneMouseOut);
		}
		 * 
		 */
		
		private function onStoneClick(event:MouseEvent):void {
			
		}
		
		private function onStoneMouseOver(event:MouseEvent):void {
			
		}
		private function onStoneMouseOut(event:MouseEvent):void {
			
		}
		
	}
}