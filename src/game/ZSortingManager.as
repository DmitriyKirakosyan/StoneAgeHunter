package game {
	import animation.IcSprite;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import game.gameActor.IcActor;

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
				if (_gameContainer.getChildAt(i) is IcSprite) {
					checkWithAll(_gameContainer.getChildAt(i) as IcSprite);
				}
			}
		}
		
		private function checkWithAll(actor:IcSprite):void {
			var child:*;
			for (var i:int = 0; i < _gameContainer.numChildren; ++i) {
				child = _gameContainer.getChildAt(i)
				if (actor != child && child is IcSprite) {
					if (crossActors(actor, child) && needSwitchActors(actor, child)) {
						_gameContainer.setChildIndex(child, _gameContainer.getChildIndex(actor));
						_gameContainer.setChildIndex(actor, i);
					}
				}
			}
		}
		
		private function needSwitchActors(one:IcSprite, two:IcSprite):Boolean {
			return ((oneAboveTwoByLegs(two, one)) && _gameContainer.getChildIndex(one) < _gameContainer.getChildIndex(two)) ||
				((oneAboveTwoByLegs(one,  two)) && _gameContainer.getChildIndex(one) > _gameContainer.getChildIndex(two));
		}

		private function oneAboveTwoByCenter(one:DisplayObject, two:DisplayObject):Boolean {
			return one.y < two.y;
		}

		private function oneAboveTwoByLegs(one:DisplayObject, two:DisplayObject):Boolean {
			return one.y + one.height/2.5 < two.y + two.height/2.5;
		}
		
		private function crossActors(one:DisplayObject, two:DisplayObject):Boolean {
			return one.hitTestObject(two);
		}
		
	}
}