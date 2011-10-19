package game.gameActor {
	import animation.IcSprite;
	
	import com.greensock.TimelineMax;
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	
	import flash.geom.Point;

	public class IcActer extends IcSprite {
		private var _speed:Number;
		private var _path:Path;
		private var _pathTimeline:TimelineMax;
		private var _moving:Boolean;
		
		private var _isNormalRotation:Boolean;

		protected const ANIMATE_MOVE:String = "move";
		protected const ANIMATE_STAY:String = "stay";
		
		public function IcActer() {
			super();
			_isNormalRotation = true;
			_speed = 1;
			_moving = false;
		}
		
		public function get pathTimeline():TimelineMax {
			return _pathTimeline;
		}
		public function set pathTimeline(value:TimelineMax):void {
			_pathTimeline = value;
		}
		
		public function get speed():Number { return _speed; }
		public function set speed(value:Number):void {
			_speed = value;
		}
		
		public function getLastPoint():Point {
			if (_path && _path.points.length > 0) {
				return _path.points[_path.points.length-1].point;
			}
			return null;
		}
		
		public function get path():Path {
			if (!_path) { _path = new Path(); }
			return _path;
		}
		
		public function move():void {
			if (_pathTimeline && _path) { _pathTimeline.play(); }
		}
		
		public function pauseMove():void {
			trace("pause");
			if (_pathTimeline) { _pathTimeline.pause(); }
		}

		protected function stop():void {
			_path = null;
		}
		
		public function computeDuration(one:Point, two:Point):Number {
			return Point.distance(one, two) / 200;
		}
		
		public function startPath(point:Point):void {
			if (!_path) { _path = new Path(); }
			_path.startPath(point);
		}
		
		public function removePrevTween():void {
			if (_pathTimeline) {
				_pathTimeline.vars["onComplete"] = null;
				_pathTimeline.kill();
				_pathTimeline = null;
			}
		}

		public function addWayPoint(point:Point):void {
			if (!_path) { _path = new Path(); }
			var prevPoint:Point;
			if (!_path.exists(point)) {
				prevPoint  = _path.getLastPoint() || new Point(this.x, this.y);
				_path.addPoint(point);
				addPointToTimeline(point, computeDuration(prevPoint, point));
			}
		}
		
		private function addPointToTimeline(point:Point, duration:Number):void {
			if (!_pathTimeline) {
				_pathTimeline = new TimelineMax({onComplete : stop});
			}
			_pathTimeline.append(new TweenLite(this, duration / _speed,
																					{x : point.x, y : point.y - this.height/4,
																						ease : Linear.easeNone,
																						onStart : onStartPoint,
																						onStartParams : [point],
																						onComplete : onTweenComplete}));
			if (_pathTimeline.paused) { trace("paused"); }
			_pathTimeline.play();
		}
		
		private function onStartPoint(point:Point):void {
			changeAnimationAndRotation(point);
			const prevPoint:KeyPoint = _path.getPreviouseKeyPoint(point); //realy it is current duck position
			if (prevPoint) {
				dispatchEvent(new KeyPointEvent(KeyPointEvent.REMOVE_ME, prevPoint));
				_path.removePreviouseKeyPoint(point);
			}
		}
		
		private function onTweenComplete():void {
			dispatchEvent(new IcActerEvent(IcActerEvent.TWEEN_TICK, this));
		}
		
		protected function changeAnimationAndRotation(targetPoint:Point):void {
			if (targetPoint.y < this.y) {
				changeToBackAnimation();
			} else { changeToFrontAnimation(); }
			if (_isNormalRotation && this.x < targetPoint.x) {
				_isNormalRotation = false;
				this.scaleX = -this.scaleX; this.x += this.width;
			} else if (!_isNormalRotation && this.x > targetPoint.x) {
				_isNormalRotation = true;
				this.scaleX = -this.scaleX; this.x -= this.width;
			}
		}
		
	}
}
