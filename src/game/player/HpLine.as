package game.player {
	import flash.display.Sprite;

	public class HpLine extends Sprite {
		
		private var _value:Number;
		private var _maxValue:Number;
		
		public function HpLine(maxValue:Number) {
			super();
			_maxValue = maxValue;
			_value = maxValue;
			updateView();
		}
		
		public function get value():Number { return _value; }
		public function set value(value:Number):void {
			_value = value;
			if (_value < 0) { _value = 0; }
			updateView();
		}
		
		public function damage(value:Number):void {
			_value -= value;
			if (_value < 0) { _value = 0; }
			updateView();
		}
		
		/* Internal functions */
		private function updateView():void {
			this.graphics.clear();
			this.graphics.beginFill(0xffaaaa);
			this.graphics.lineStyle(1, 0x000033);
			this.graphics.drawRect(0, 0, 20 * _value, 6);
			this.graphics.endFill();
		}
	}
}
