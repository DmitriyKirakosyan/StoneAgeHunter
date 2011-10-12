package game.gameActor {
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.display.Sprite;
	public class KeyPoint extends Sprite{
		private var _point:Point;
		
		private const NORMAL_COLOR:uint = 0xafafaa;
		private const SELECTED_COLOR:uint = 0xac61fa;
		public function KeyPoint(point:Point):void {
			super();
			x = point.x;
			y = point.y;
			_point = point;
			draw(NORMAL_COLOR);
			addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		public function get point():Point { return _point; }
		
		public function select():void {
			draw(SELECTED_COLOR);
		}
		public function unselect():void {
			draw(NORMAL_COLOR);
		}
		
		private function draw(lineColor:uint):void {
			this.graphics.beginFill(0x0f0fab, .7);
			this.graphics.lineStyle(2, lineColor);
			this.graphics.drawCircle(0, 0, 5);
			this.graphics.endFill();
		}
		
		private function onMouseClick(event:MouseEvent):void {
			dispatchEvent(new KeyPointEvent(KeyPointEvent.CLICK, this));
		}
	}
}
