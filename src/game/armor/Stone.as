package game.armor {
	import flash.display.Sprite;

	public class Stone extends Sprite {
		public function Stone() {
			draw();
		}
		
		private function draw():void {
			this.graphics.beginFill(0x0fafcd);
			this.graphics.drawCircle(0, 0, 5);
			this.graphics.endFill();
		}
	}
}
