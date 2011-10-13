package game.animals {
	import com.greensock.easing.Linear;
	import com.greensock.TimelineMax;
	import com.adobe.serialization.json.JSON;
	import animation.IcSprite;
	
	import com.greensock.TweenLite;
	
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	
	import game.HpLine;
	import game.gameActor.IcActer;

	public class Duck extends IcActer {
		private var _enemies:Vector.<IcSprite>;
		private var _patrolPath:Vector.<Point>;
		private var _mode:uint;
		private var _paused:Boolean;
		
		private var _currentTween:TweenLite;
		private var _timelineMax:TimelineMax;
		
		private var _hp:HpLine;
		
		public static const MODE_NOTHING:uint = 0;
		public static const MODE_BLOODY:uint = 1;
		public static const MODE_STALS:uint = 2;
		
		private const ANIMATE_STAY:String = "stay";
		private const ANIMATE_MOVE:String = "move";
		
		public function Duck() {
			super();
			_mode = MODE_BLOODY;
			_paused = true;
			speed = .5;
			setScale();
			drawDuck();
			createHp();
			addAnimations();
			play(ANIMATE_STAY);
		}
		
		public function setJsonPath(json:String):void {
			var jsonObject:Object = JSON.decode(json);
			_patrolPath = new Vector.<Point>();
			if (jsonObject is Array) {
				for each (var pointObj:Object in jsonObject) {
					_patrolPath.push(new Point(pointObj["x"], pointObj["y"]));
				}
			}
		}
		
		public function setScale():void {
			this.scaleX = .4;
			this.scaleY = .4;
		}
		
		public function createHp():void {
			_hp = new HpLine(5);
			_hp.y = -20;
			_hp.x = -20;
			this.addChild(_hp);
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
			} else { tweenToStartPatrolPath(); }
		}
		
		override public function pauseMove():void {
			play(ANIMATE_STAY);
			//if (_currentTween) { _currentTween.pause(); }
			_paused = true;
		}
		
		/* Internal functions */

		private function tweenPatrolPath():TimelineMax {
			trace("tweeNPatrolPath");
			
			var resultTimeline:TimelineMax = new TimelineMax({ repeat : -1 });
			resultTimeline.killTweensOf(this);
			for (var i:int = 0; i < _patrolPath.length; ++i) {
				if (i > -1) { resultTimeline.append( createTweenToPoint(_patrolPath[i]) ); }
			}
			if (_patrolPath && _patrolPath.length > 0) {
				resultTimeline.append(createTweenToPoint(_patrolPath[0]));
			}
			return resultTimeline;
			//if (_paused) { _currentTween.pause(); }
		}
		
		private function tweenToStartPatrolPath():void {
			if (_patrolPath && _patrolPath.length > 0) {
				_timelineMax = new TimelineMax();
				_timelineMax.append(createTweenToPoint(_patrolPath[0], tweenPatrolPath));
				_timelineMax.append(tweenPatrolPath());
			}
		}
		
		private function createTweenToPoint(point:Point, onComplete:Function = null):TweenLite {
			var duration:Number = computeDuration(new Point(this.x, this.y), point) / speed;
			return new TweenLite(this, duration, {x : point.x, y : point.y, ease:Linear.easeNone, onStart : onTweenStart, onComplete : onComplete});
		}
		
		private function onTweenStart():void { trace("tween start, tweens number : ", _timelineMax ? _timelineMax.getTweensOf(this).length : 0); }
		
		private function addAnimations():void {
			addAnimation(ANIMATE_STAY, new DuckStayD());
			addAnimation(ANIMATE_MOVE, new DuckWalkD());
		}
		
		private function drawDuck():void {
			addChild(new DuckStayD());
		}
	}
}
