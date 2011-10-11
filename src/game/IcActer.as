package game {
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import com.greensock.TimelineMax;
	import flash.geom.Point;
	import animation.IcSprite;

	public class IcActer extends IcSprite {
		private var _speed:Number;
		private var _path:Path;
		private var _pathTimeline:TimelineMax;
		private var _moving:Boolean;

		public function IcActer() {
			super();
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
			return _path;
		}
		
		public function move():void {
			if (_pathTimeline && _path) { _pathTimeline.play(); }
		}
		
		public function pauseMove():void {
			if (_pathTimeline) { _pathTimeline.pause(); }
		}

		protected function stopMove():void {
			_path = null;
		}
		
		public function computeDuration(one:Point, two:Point):Number {
			return Point.distance(one, two) / 200;
		}
		
		public function startPath(point:Point):void {
			if (!_path) { _path = new Path(); }
			_path.startPath(point);
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
				_pathTimeline = new TimelineMax({onComplete : stopMove });
				_pathTimeline.pause();
			}
			
			_pathTimeline.append(new TweenLite(this, duration / _speed,
																					{x : point.x - this.width/2, y : point.y - this.height/2,
																						ease : Linear.easeNone,
																						onStart : onStartPoint,
																						onStartParams : [point]}));
			if (_pathTimeline.paused) { trace("paused"); }
		}
		
		private function onStartPoint(point:Point):void {
			const prevPoint:KeyPoint = _path.getPreviouseKeyPoint(point);
			if (prevPoint) {
				dispatchEvent(new KeyPointEvent(KeyPointEvent.REMOVE_ME, prevPoint));
				_path.removePreviouseKeyPoint(point);
			}
		}
		
	}
}
