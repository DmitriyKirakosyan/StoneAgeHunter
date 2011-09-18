package game.animals {
	import flash.text.TextField;
	import animation.IcSprite;

	public class Duck extends IcSprite {
		public function Duck() {
			super();
			drawDuck();
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
