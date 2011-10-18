package game.animals {
	import animation.IcSprite;
	
	import com.adobe.serialization.json.JSON;
	import com.greensock.TimelineMax;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
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
		
		public static const MODE_SELF_PATH:uint = 0;
		public static const MODE_BLOODY:uint = 1;
		public static const MODE_STALS:uint = 2;
		
		public function Duck() {
			super();
			_mode = MODE_SELF_PATH;
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
			_mode = MODE_SELF_PATH;
			if (_currentTween) { _currentTween.kill(); }
		}
		
		override public function move():void {
			_paused = false;
			play(ANIMATE_MOVE);
			if (!_timelineMax) { tweenToStartPatrolPath(); }
		}
		
		override public function pauseMove():void {
			play(ANIMATE_STAY);
			_paused = true;
		}
		
		/* Internal functions */

		private function tweenPatrolPath():void {
			var prevPoint:Point;
			
			_timelineMax = new TimelineMax({ repeat : -1 });
			_timelineMax.stop();
			_timelineMax.killTweensOf(this);
			for (var i:int = 0; i < _patrolPath.length; ++i) {
				if (i > 0) {
					prevPoint = _patrolPath[i-1];
					_timelineMax.append( createTweenToPoint(_patrolPath[i], prevPoint, onTweenStart) );
					}
			}
			if (_patrolPath && _patrolPath.length > 0) {
				_timelineMax.append(createTweenToPoint(_patrolPath[0], _patrolPath[_patrolPath.length-1], onTweenStart));
			}
			_timelineMax.play();
		}
		
		private function onTweenStart(point:Point):void {
			trace("tween start");
			changeAnimationAndRotation(point);
		}
		
		private function tweenToStartPatrolPath():void {
			if (_patrolPath && _patrolPath.length > 0) {
				createTweenToPoint(_patrolPath[0], new Point(this.x, this.y), onTweenStart, tweenPatrolPath);
			}
		}
		
		private function createTweenToPoint(point:Point, prevPoint:Point, onStart:Function =  null, onComplete:Function = null):TweenMax {
			var duration:Number = computeDuration(prevPoint, point.clone()) / speed;
			var duck:Duck = this;
			return new TweenMax(duck, duration, { x : point.x, y : point.y, ease:Linear.easeNone,
																						onStart : onStart, onStartParams : [point], onComplete : onComplete});
		}
		
		private function addAnimations():void {
			addAnimation(ANIMATE_STAY, new DuckStayD(), new DuckStayU());
			addAnimation(ANIMATE_MOVE, new DuckWalkD(), new DuckWalkU());
		}
		
		private function drawDuck():void {
			addChild(new DuckStayD());
		}
	}
}
