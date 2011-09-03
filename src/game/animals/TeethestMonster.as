package game.animals {

	public class TeethestMonster extends Animal {
		public function TeethestMonster() {
			super();
			draw();
		}
		
		/* Internal functions */
		
		private function draw():void {
			this.graphics.beginFill(0x9f00fa);
			this.graphics.drawRect(-20, -20, 40, 40);
			this.graphics.endFill();
		}
	}
}
