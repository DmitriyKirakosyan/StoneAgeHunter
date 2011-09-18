package game {
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import com.greensock.TimelineMax;
	import flash.geom.Point;
	import animation.IcSprite;

	public class IcActer extends IcSprite {
		private var _speed:Number;
		private var _path:Vector.<Point>;
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
		
		public function get speed():Number { return _speed; }
		public function set speed(value:Number):void {
			_speed = value;
		}
		
		public function getLastPoint():Point {
			if (_path && _path.length > 0) {
				return _path[_path.length-1];
			}
			return null;
		}
		
		public function get path():Vector.<Point> {
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

		public function addWayPoint(point:Point):void {
			if (!_path) { _path = new Vector.<Point>(); }
			var duration:Number;
			var prevPoint:Point;
			if (_path.indexOf(point) == -1) {
				prevPoint  = _path.length > 0 ? _path[_path.length-1] : 
																				new Point(this.x, this.y);
				duration = Math.abs(prevPoint.x * prevPoint.x - point.x * point.x) +
										Math.abs(prevPoint.y * prevPoint.y - point.y * point.y);
				duration = Math.sqrt(duration);
				_path.push(point);
				addPointToTimeline(point, duration/200);
			}
		}
		
		private function addPointToTimeline(point:Point, duration:Number):void {
			if (!_pathTimeline) {
				_pathTimeline = new TimelineMax({onComplete : stopMove });
				_pathTimeline.pause();
			}
			
			_pathTimeline.append(new TweenLite(this, duration * _speed,
																					{x : point.x - this.width/2, y : point.y - this.height/2,
																						ease : Linear.easeNone,
																						onStart : onStartPoint,
																						onStartParams : [point]}));
		}
		
		private function onStartPoint(point:Point):void {
			if (_path && _path.length > 0) {
				removePreviousePoint(point);
			} else {
				trace("[Hunter.onStartPoint] somthing wrong");
			}
		}
		
		private function removePreviousePoint(point:Point):void {
			const index:int = _path.indexOf(point);
			var iter:int = index-1;
			if (index != -1) {
				while (iter >= 0) { _path.shift(); iter--; }
			}
		}
		
	}
}
