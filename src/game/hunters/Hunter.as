package game.hunters {
	import org.flixel.FlxSprite;
	import flash.display.BitmapData;
	import events.HunterEvent;
	import flash.events.MouseEvent;
	import flash.display.Sprite;

	public class Hunter {
		private var _view:FlxSprite;
		public function Hunter(x:Number, y:Number, graphic:Class) {
			super();
			_view = new FlxSprite(x, y, graphic);
			//draw();
			//addListeners();
		}
		
		public function get view():FlxSprite {
			return _view;
		}
		
		/* internal functions */
/*		
		private function draw():void {
			this.graphics.beginFill(0x93f322);
			this.graphics.drawCircle(0, 0, 8);
			this.graphics.endFill();
		}
		 * 
		 */
		
		//private function addListeners():void {
			//_view. addEventListener(MouseEvent.CLICK, onClick);
		//}
		
		//private function onClick(event:MouseEvent):void {
		//	dispatchEvent(new HunterEvent(HunterEvent.CLICK, this));
		//}
	}
}
