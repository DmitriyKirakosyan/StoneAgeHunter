package game.animals {
	import game.GameController;
	import flash.display.Sprite;

	public class AnimalsController {
		private var _container:Sprite;
		private var _animals:Vector.<Animal>;
		
		public function AnimalsController(container:Sprite):void {
			super();
			_container = container;
		}
		
		/* API */
			public function createAnimals():void {
				_animals = new Vector.<Animal>();
				var monster:TeethestMonster;
				for (var i:int = 0; i < 2; ++i) {
					monster = new TeethestMonster();
					monster.x = GameController.GAME_WIDTH/4 +
											monster.width/2 + Math.random()*(GameController.GAME_WIDTH/2-monster.width);
					monster.y = GameController.GAME_HEIGHT/4 +
											monster.height/2 + Math.random()*(GameController.GAME_HEIGHT/2-monster.height);
					_animals.push(monster);
					_container.addChild(monster);
				}
			}
		
		/* Internal functions */
	}
}
