package game.hunters {
	import events.HunterEvent;
	import flash.events.MouseEvent;
	import flash.display.Sprite;

	public class Hunter extends Sprite {
		public function Hunter() {
			super();
			draw();
			addListeners();
		}
		
		/* internal functions */
		
		private function draw():void {
			this.graphics.beginFill(0x93f322);
			this.graphics.drawCircle(0, 0, 8);
			this.graphics.endFill();
		}
		
		private function addListeners():void {
			this.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClick(event:MouseEvent):void {
			dispatchEvent(new HunterEvent(HunterEvent.CLICK, this));
		}
	}
}
