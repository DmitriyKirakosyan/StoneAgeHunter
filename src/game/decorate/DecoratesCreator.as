package game.decorate {
	import flash.display.Sprite;
	import game.armor.Stone;
	import game.GameScene;
	/**
	 * ...
	 * @author Dima
	 */
	public class DecoratesCreator {
		private var _paddle:DecorativeObject;
		private var _decorativeObjects:Vector.<DecorativeObject>;
		
		private var _container:Sprite;
		
		
		public function DecoratesCreator() {
			_decorativeObjects = new Vector.<DecorativeObject>();
			_container = new Sprite();
		}
		
		public function get container():Sprite { return _container; }
		
		public function create():void {
			createDecorativeObjects();
		}
		public function remove():void {
			removeDecorativeObjects();
		}
		
		private function addStone():void {
			var stone:DecorativeObject = DecorativeObject.createLittleHill();
			stone.x = Math.random() * (GameScene.WIDTH-100) + 50;
			_container.addChild(stone);
			stone.y = Math.random() * (GameScene.HEIGHT-100) +50;
			_decorativeObjects.push(stone);
		}

		//делаем всякие камушки - хуямушки
		private function createDecorativeObjects():void {
			for (var i:int = 0; i < 10; i++){
				addStone();
			}
			_paddle = DecorativeObject.createPaddle();
			_container.addChild(_paddle);
			_paddle.x = 200;
			_paddle.y= 200;
			_paddle.underAll = true;
		}
		
		private function removeDecorativeObjects():void {
			for each (var dObject:DecorativeObject in _decorativeObjects) {
				if (_container.contains(dObject)) {
					_container.removeChild(dObject);
				}
			}
			if (_container.contains(_paddle)) {
				_container.removeChild(_paddle);
			}
		}
		
	}
}