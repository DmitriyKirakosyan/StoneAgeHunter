package game {
	import com.greensock.TweenMax;
	import flash.filters.BlurFilter;
	import animation.IcSprite;
	import flash.display.Sprite;
	public class DreamChanger {
		private var _gameScene:GameScene;
		private var _parentContainer:Sprite;
		private var _gameContainer:Sprite;
		private var _mapContainer:Sprite;
		private var _alterContainer:Sprite;
		private var _indexOfGameContainer:int;
		private var _indexOfMapContainer:int;
		
		private var _alterObjects:Vector.<Sprite>;
		
		private var _mode:String;
		
		public static const GAME_MODE:String = "gameMode";
		public static const PLAN_MODE:String = "planMode";
		
		public function DreamChanger(gameScene:GameScene, parentContainer:Sprite):void {
			super();
			_mode = GAME_MODE;
			_parentContainer = parentContainer;
			_gameScene = gameScene;
			_gameContainer = gameScene.gameContainer;
			_mapContainer = gameScene.mapContainer;
			_indexOfGameContainer = _parentContainer.getChildIndex(_gameContainer);
			_indexOfMapContainer = _parentContainer.getChildIndex(_mapContainer);
		}
		
		public function dreamOn():void {
			/*
			if (_mode == PLAN_MODE) { return; }
			_mode = PLAN_MODE;
			_alterContainer = new Sprite();
			_alterObjects = new Vector.<Sprite>();
			
			
			const tileMap:Sprite = _gameScene.tileMap.getAlternativeCopy();
			_alterObjects.push(tileMap);
			_alterContainer.addChild(tileMap);
			const gameObjects:Vector.<Sprite> = _gameScene.getDreamingObjects();
			var alterCopy:Sprite;
			for each (var object:IcSprite in gameObjects) {
				alterCopy = object.getAlternativeCopy();
				_alterContainer.addChild(alterCopy);
				_alterObjects.push(alterCopy);
			}
			changeToAlterContainer();
			*/
		}
		
		public function dreamOff():void {
			if (_mode == GAME_MODE) { return; }
			_mode = GAME_MODE;
/*			if (_alterObjects && _alterContainer) {
				for each (var object:Sprite in _alterObjects) {
					_alterContainer.removeChild(object);
				}
				_parentContainer.removeChild(_alterContainer);
			}
			 * 
			 */
			changeToGameContainer();
		}
		
		/* Internal functions */
		
		private function changeToAlterContainer():void {
			_alterContainer.filters = [new BlurFilter(40, 0, 5)];
			_alterContainer.alpha = 0;
			_parentContainer.addChild(_alterContainer);
			TweenMax.to(_alterContainer, 2, {blurFilter:{blurX:0, streight : 5}, alpha : 1});
			TweenMax.to(_gameContainer, 2, {blurFilter:{blurX:40, streight : 5}, alpha : 0,
																			onComplete : removeFromParent, onCompleteParams : [_gameContainer]});
			TweenMax.to(_mapContainer, 2, {blurFilter:{blurX:40, streight : 5}, alpha : 0,
																			onComplete : removeFromParent, onCompleteParams : [_mapContainer]});
		}
		
		private function removeFromParent(sprite:Sprite):void {
			_parentContainer.removeChild(sprite);
			trace("remove from parent");
		}
		
		private function changeToGameContainer():void {
			_parentContainer.addChildAt(_gameContainer, _indexOfGameContainer);
			_parentContainer.addChildAt(_mapContainer, _indexOfMapContainer);
			TweenMax.to(_gameContainer, 1, {blurFilter:{blurX:0, streight : 5}, alpha : 1});
			TweenMax.to(_mapContainer, 1, {blurFilter:{blurX:0, streight : 5}, alpha : 1});
			TweenMax.to(_alterContainer, 1, {blurFilter:{blurX:20, streight : 5}, alpha : 0,
																			onComplete : removeFromParent, onCompleteParams : [_alterContainer]});
		}
		
	}
}
