package game.animals {
	import com.greensock.TimelineMax;
	import flash.text.TextFieldAutoSize;
	import flash.geom.Point;
	import game.IcActer;
	import game.HpLine;
	import flash.text.TextField;
	import animation.IcSprite;

	public class Duck extends IcActer {
		private var _enemies:Vector.<IcSprite>;
		private var _targetEnemy:IcSprite;
		
		private var _hp:HpLine;
		
		public function Duck() {
			super();
			drawDuck();
			_hp = new HpLine(5);
			_hp.y = -20;
			_hp.x = -20;
			this.addChild(_hp);
		}
		
		public function addEnemy(enemy:IcSprite):void {
			if (!_enemies) { _enemies = new Vector.<IcSprite>(); }
			_enemies.push(enemy);
		}
		
		override protected function stopMove():void {
			super.stopMove();
			trace("stop duck move");
			//pathTimeline = null;
			updateTarget();
		}
		
		public function updateTarget():void {
			var goodEnemy:IcSprite;
			for each (var enemy:IcSprite in _enemies) {
				if (!goodEnemy ||
						((goodEnemy.x + goodEnemy.y) > (enemy.x + enemy.y))) {
					goodEnemy = enemy;
				}
			}
			if (_targetEnemy != goodEnemy) {
				_targetEnemy = goodEnemy;
			}
			trace("add way point for duck");
			trace("x : " + _targetEnemy.x + ", y : " + _targetEnemy.y);
			addWayPoint(new Point(_targetEnemy.x + _targetEnemy.width/2, _targetEnemy.y + _targetEnemy.height/2));
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
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.selectable = false;
			this.addChild(textField);
		}
	}
}
