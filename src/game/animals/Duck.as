package game.animals {
	import game.IcActer;
	import game.HpLine;
	import flash.text.TextField;
	import animation.IcSprite;

	public class Duck extends IcActer {
		private var _enemies:Vector.<IcSprite>;
		
		private var _hp:HpLine;
		
		public function Duck() {
			super();
			drawDuck();
			_hp = new HpLine(5);
			_hp.y = -20;
			_hp.x = -20;
			this.addChild(_hp);
		}
		
		public function addEnemy(enemy:IcSprite):void {
			if (!_enemies) { _enemies = new Vector.<IcSprite>(); }
			_enemies.push(enemy);
		}
		
		/* Internal functions */
		
		private function drawDuck():void {
			this.graphics.beginFill(0x0fac00);
			this.graphics.drawEllipse(0, 0, 40, 60);
			this.graphics.endFill();
			var textField:TextField = new TextField();
			textField.text = "Утк";
			textField.x = 10;
			textField.y = 25;
			textField.selectable = false;
			this.addChild(textField);
		}
	}
}
