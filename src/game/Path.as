package game {
	import flash.geom.Point;
	public class Path {
		private var _keyPoints:Vector.<KeyPoint>;
		private var _links:Vector.<LinkToPoint>;
		
		public function Path():void {
			super();
		}
		
		public function get points():Vector.<KeyPoint> { return _keyPoints; }
		
		public function addPoint(point:Point):void {
			if (!_keyPoints) { _keyPoints = new Vector.<KeyPoint>(); }
			_keyPoints.push(new KeyPoint(point));
		}
		
		public function exists(point:Point):Boolean {
			for each (var keyPoint:KeyPoint in _keyPoints) {
				if (keyPoint.point == point) { return true; }
			}
			return false;
		}
		
		public function getLastPoint():Point {
			if (_keyPoints && _keyPoints.length > 0) {
				return _keyPoints[_keyPoints.length - 1].point;
			}
			return null;
		}
		
		public function getLastKeyPoint():KeyPoint {
			if (_keyPoints && _keyPoints.length > 0) {
				return _keyPoints[_keyPoints.length - 1];
			}
			return null;
		}
		
		public function removePreviouseKeyPoint(point:Point):void {
			const keyPoint:KeyPoint = getKeyPoint(point);
			if (!keyPoint) { return; }
			const index:int = _keyPoints.indexOf(keyPoint);
			var iter:int = index-1;
			if (index != -1) {
				while (iter >= 0) { _keyPoints.shift(); iter--; }
			}
		}
		
		public function getPreviouseKeyPoint(point:Point):KeyPoint {
			const keyPoint:KeyPoint = getKeyPoint(point);
			if (!keyPoint) { return null; }
			const index:int = _keyPoints.indexOf(keyPoint);
			if (index-1 >= 0) {
				return _keyPoints[index-1];
			}
			return null;
		}
		
		private function getKeyPoint(point:Point):KeyPoint {
			for each (var keyPoint:KeyPoint in _keyPoints) {
				if (keyPoint.point == point) {
					return keyPoint;
				}
			}
			return null;
		}
		
	}
}
