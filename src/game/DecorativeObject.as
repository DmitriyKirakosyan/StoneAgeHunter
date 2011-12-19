package game {
	import animation.IcSprite;
	
	import flash.display.Sprite;

public class DecorativeObject extends IcSprite {
		public function DecorativeObject(view:Sprite) {
			super();
			addChild(view);
		}

		public static function createLittleHill():DecorativeObject {
			return new DecorativeObject(LevelDecorationManager.getDecorationElement("littleHill"));
		}
		public static function createPaddle():DecorativeObject {
			return new DecorativeObject(LevelDecorationManager.getDecorationElement("paddle"));
		}
	}
}