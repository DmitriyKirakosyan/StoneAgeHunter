package game.animal {
	import animation.IcSprite;

import com.adobe.serialization.json.JSON;
import com.greensock.TimelineMax;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;

import flash.display.Sprite;

import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.geom.Point;

import game.enemy.EnemyDirectionPointer;

import game.player.HpLine;
	import game.gameActor.IcActor;
	import game.player.Hunter;
import game.pointer.HiddenObjectPointer;

public class Duck extends IcActor {
		private var _patrolPath:Vector.<Point>;
		private var _mode:uint;
		private var _paused:Boolean;
		
		private var _targetHunter:Hunter;
		
		private var _timelineMax:TimelineMax;

		private var _directionPointer:HiddenObjectPointer;
		
		public static const MODE_PATROL:uint = 0;
		public static const MODE_BLOODY:uint = 1;
		public static const MODE_NOTHING:uint = 3;
		
		public function Duck(speed:Number) {
			super();
			super.speed = speed;
			_paused = true;
			//_directionPointer = new EnemyDirectionPointer(Main.WIDTH, Main.HEIGHT);
			setScale(.3);
			addAnimations();
			play(ANIMATE_STAY);
		}

		public function get directionPointer():HiddenObjectPointer { return _directionPointer; }
		public function set directionPointer(value:HiddenObjectPointer):void { _directionPointer = value; }
		public function updateDirectionPointer():void {
			_directionPointer.updatePosition();
		}

		/*
		public function setJsonPath(json:String):void {
			var jsonObject:Object = JSON.parse(json);
			_patrolPath = new Vector.<Point>();
			if (jsonObject is Array) {
				for each (var pointObj:Object in jsonObject) {
					_patrolPath.push(new Point(pointObj["x"], pointObj["y"]));
				}
			}
		}
		*/
		
		public function goForPatrolPath():void {
			if (_patrolPath && _patrolPath.length > 0) {
				createTweenToPoint(_patrolPath[0], new Point(this.x, this.y), onTweenStart, tweenPatrolPath);
			}
		}
		
		public function fasHunter(hunter:Hunter):void {
			_targetHunter = hunter;
			_mode = MODE_BLOODY;
			stopMoving();
			followHunter();
		}
		
		public function setScale(value:Number):void {
			animationScale = value;
		}

	public function stopMoving():void {
		if (_timelineMax) {
			_timelineMax.vars["onComplete"] = null;
			_timelineMax.kill();
		}
	}

	public function dead():void {
		stopMoving();
		play(DuckAnimationBuilder.ANIMATION_HIT);
	}

		override public function move():void {
			_paused = false;
			play(ANIMATE_MOVE);
			if (!_timelineMax) { goForPatrolPath(); }
		}
		
		override public function pauseMove():void {
			play(ANIMATE_STAY);
			_paused = true;
		}
		
		/* Internal functions */
		
		private function followHunter():void {
			if (!_targetHunter) { goForPatrolPath(); return; }
			var duration:Number = computeDuration(new Point(this.x, this.y), new Point(_targetHunter.x, _targetHunter.y)) / speed;
			_timelineMax = new TimelineMax();
			_timelineMax.stop();
			_timelineMax.killTweensOf(this);
			_timelineMax.append(new TweenMax(this, duration, {x : _targetHunter.x, y : _targetHunter.y, ease : Linear.easeNone,
				onComplete : onFollowHunterComplete}));
			
			_timelineMax.play();
			play(DuckAnimationBuilder.ANIMATION_MOVE);
			changeAnimationAndRotation(new Point(_targetHunter.x, _targetHunter.y));
		}
		
		private function onFollowHunterComplete():void {
			_mode = MODE_NOTHING;
			play(DuckAnimationBuilder.ANIMATION_STAY);
			dispatchEvent(new AnimalEvent(AnimalEvent.FOLLOW_COMPLETE, _targetHunter));
		}
		
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
		
		private function createTweenToPoint(point:Point, prevPoint:Point, onStart:Function =  null, onComplete:Function = null):TweenMax {
			var duration:Number = computeDuration(prevPoint, point.clone()) / speed;
			var duck:Duck = this;
			return new TweenMax(duck, duration, { x : point.x, y : point.y, ease:Linear.easeNone,
																						onStart : onStart, onStartParams : [point], onComplete : onComplete});
		}
		
		private function addAnimations():void {
			var animationBuilder:DuckAnimationBuilder = new DuckAnimationBuilder();
			addAnimation(animationBuilder.createStayAnimation());
			addAnimation(animationBuilder.createMoveAnimation());
			addAnimation(animationBuilder.createHitAnimation());
		}
		
	}
}
