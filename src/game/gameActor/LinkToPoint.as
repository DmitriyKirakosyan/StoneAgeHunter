package game.gameActor {
	import flash.display.Sprite;

	public class LinkToPoint extends Sprite {
		private var _from:KeyPoint;
		private var _to:KeyPoint;
		
		private var _color:uint;
		
		public function LinkToPoint(from:KeyPoint, to:KeyPoint, color:uint) {
			super();
			_from = from;
			_to = to;
			_color = color;
			drawLink();
		}
		
		private function drawLink():void {
			this.graphics.lineStyle(2, _color);
			this.graphics.moveTo(_from.x, _from.y);
			this.graphics.lineTo(_to.x, _to.y);
		}
	}
}
