package game {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import game.gameActor.IcActer;

	public class ZSortingManager {
		private var _gameScene:GameScene;
		private var _gameContainer:Sprite;
		
		public function ZSortingManager(gameScene:GameScene) {
			super();
			_gameScene = gameScene;
			_gameContainer = gameScene.gameContainer;
		}
		
		public function checkZSorting():void {
			for (var i:int = 0; i < _gameContainer.numChildren; ++i) {
				if (_gameContainer.getChildAt(i) is IcActer) {
					checkWithAll(_gameContainer.getChildAt(i) as IcActer);
				}
			}
		}
		
		private function checkWithAll(actor:IcActer):void {
			var child:DisplayObject;
			for (var i:int = 0; i < _gameContainer.numChildren; ++i) {
				child = _gameContainer.getChildAt(i)
				if (actor != child && child is IcActer) {
					if (crossActors(actor, child) && needSwitchActors(actor, child)) {
						_gameContainer.setChildIndex(child, _gameContainer.getChildIndex(actor));
						_gameContainer.setChildIndex(actor, i);
					}
				}
			}
		}
		
		private function needSwitchActors(one:DisplayObject, two:DisplayObject):Boolean {
			return (one.y > two.y && _gameContainer.getChildIndex(one) < _gameContainer.getChildIndex(two)) ||
				(one.y < two.y && _gameContainer.getChildIndex(one) > _gameContainer.getChildIndex(two));
		}
		
		private function crossActors(one:DisplayObject, two:DisplayObject):Boolean {
			return one.hitTestObject(two);
		}
		
	}
}