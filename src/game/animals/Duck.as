package game.animals {
	import animation.IcSprite;
	
	import com.greensock.TweenLite;
	
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	
	import game.HpLine;
	import game.gameActor.IcActer;

	public class Duck extends IcActer {
		private var _enemies:Vector.<IcSprite>;
		private var _targetEnemy:IcSprite;
		private var _mode:uint;
		private var _paused:Boolean;
		
		private var _currentTween:TweenLite;
		
		private var _hp:HpLine;
		
		public static const MODE_NOTHING:uint = 0;
		public static const MODE_BLOODY:uint = 1;
		public static const MODE_STALS:uint = 2;
		
		private const ANIMATE_STAY:String = "stay";
		private const ANIMATE_MOVE:String = "move";
		
		public function Duck() {
			super();
			this.scaleX = .4;
			this.scaleY = .4;
			_mode = MODE_BLOODY;
			_paused = true;
			speed = .5;
			drawDuck();
			_hp = new HpLine(5);
			_hp.y = -20;
			_hp.x = -20;
			this.addChild(_hp);
			addAnimations();
			play(ANIMATE_STAY);
		}
		
		public function get hp():Number { return _hp.value; }
		public function set hp(value:Number):void {
			_hp.value = value;
		}
		
		public function mouseOver():void {
			filters = [new GlowFilter(0xffaa33)];
		}
		public function mouseOut():void {
			filters = [];
		}
		
		public function addEnemy(enemy:IcSprite):void {
			if (!_enemies) { _enemies = new Vector.<IcSprite>(); }
			_enemies.push(enemy);
		}
		
		public function remove():void {
			_mode = MODE_NOTHING;
			if (_currentTween) { _currentTween.kill(); }
		}
		
		override public function move():void {
			_paused = false;
			play(ANIMATE_MOVE);
			if (_currentTween && _currentTween.paused) {
				_currentTween.play();
			}
		}
		
		override public function pauseMove():void {
			play(ANIMATE_STAY);
			if (_currentTween) { _currentTween.pause(); }
			_paused = true;
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
			const targetPoint:Point =  new Point(_targetEnemy.x + _targetEnemy.width/2,
																						_targetEnemy.y + _targetEnemy.height/2);
			_currentTween = new TweenLite(this, computeDuration(new Point(this.x, this.y), targetPoint) / speed, 
																										{x : targetPoint.x, y : targetPoint.y,
																											onComplete : onTweenComplete,
																											onUpdate : onTweenUpdate});
			if (_paused) { _currentTween.pause(); }
		}
		
		/* Internal functions */
		
		private function addAnimations():void {
			addAnimation(ANIMATE_STAY, new DuckStayD());
			addAnimation(ANIMATE_MOVE, new DuckWalkD());
		}
		
		private function onTweenComplete():void {
			if (_mode == MODE_BLOODY) {
				updateTarget();
			}
		}
		
		private function onTweenUpdate():void {
			for each (var hunter:IcSprite in _enemies) {
				if (this.hitTestObject(hunter)) {
					dispatchEvent(new AnimalEvent(AnimalEvent.TOUCH_ACTOR, hunter));
				}
			}
		}
		
		private function drawDuck():void {
			addChild(new DuckStayD());
		}
	}
}
