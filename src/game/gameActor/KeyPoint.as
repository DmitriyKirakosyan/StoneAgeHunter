package game.gameActor {
	import utils.TwistingDot;
	import flash.filters.GlowFilter;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.display.Sprite;
	public class KeyPoint extends Sprite{
		private var _point:Point;
		
		private var _selected:Boolean;
		private var _attack:Boolean;
		
		private var _attackView:TwistingDot;
		
		private const NORMAL_COLOR:uint = 0xafafaa;
		private const SELECTED_COLOR:uint = 0xac61fa;
		public function KeyPoint(point:Point):void {
			super();
			x = point.x;
			y = point.y;
			_attack = false;
			_selected = false;
			_point = point;
			draw(NORMAL_COLOR);
			addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		public function get selected():Boolean { return _selected; }
		
		public function get point():Point { return _point; }
		
		public function set attack(value:Boolean):void { _attack = value; updateAttackView(); }
		
		public function get attack():Boolean { return _attack; }
		
		public function select():void {
			draw(SELECTED_COLOR);
			filters = [new GlowFilter(0xffffff)];
			_selected = true;
		}
		public function unselect():void {
			draw(NORMAL_COLOR);
			filters = [];
			_selected = false;
		}
		
		private function updateAttackView():void {
			if (!_attack) {
				if (_attackView && this.contains(_attackView)) { _attackView.stop(); this.removeChild(_attackView); }
			} else {
				if (!_attackView) { _attackView = new TwistingDot(); }
				this.addChild(_attackView);
				_attackView.start();
			}
		}
		
		private function draw(lineColor:uint):void {
			this.graphics.beginFill(0x0f0fab, .7);
			this.graphics.lineStyle(3, lineColor);
			this.graphics.drawCircle(0, 0, 5);
			this.graphics.endFill();
		}
		
		private function onMouseClick(event:MouseEvent):void {
			dispatchEvent(new KeyPointEvent(KeyPointEvent.CLICK, this));
		}
	}
}
