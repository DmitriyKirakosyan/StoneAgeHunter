package game {
	import flash.display.Sprite;

	public class LinkToPoint extends Sprite {
		private var _from:KeyPoint;
		private var _to:KeyPoint;
		
		public function LinkToPoint(from:KeyPoint, to:KeyPoint) {
			super();
			_from = from;
			_to = to;
			drawLink();
		}
		
		private function drawLink():void {
			this.graphics.lineStyle(2, 0xff11bb);
			this.graphics.moveTo(_from.x, _from.y);
			this.graphics.lineTo(_to.x, _to.y);
		}
	}
}
