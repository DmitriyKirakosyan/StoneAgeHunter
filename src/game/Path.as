package game {
	import flash.geom.Point;
	public class Path {
		private var _startPoint:KeyPoint;
		private var _keyPoints:Vector.<KeyPoint>;
		private var _links:Vector.<LinkToPoint>;
		
		private var _linksColor:uint;
		
		public function Path():void {
			super();
			_linksColor = 0xff11bb;
		}
		
		/* API */
		
		public function get points():Vector.<KeyPoint> { return _keyPoints; }
		public function get links():Vector.<LinkToPoint> { return _links; }
		
		public function setLinksColor(color:uint):void {
			_linksColor = color;
		}

		public function startPath(point:Point):void {
			_startPoint = new KeyPoint(point);
		}
		
		public function addPoint(point:Point):void {
			var keyPoint:KeyPoint = new KeyPoint(point);
			if (!_keyPoints) { _keyPoints = new Vector.<KeyPoint>(); }
			if (_keyPoints.length == 0 && _startPoint) {
				addLink(_startPoint, keyPoint);
			} else if (_keyPoints.length > 0) {
				addLink(_keyPoints[_keyPoints.length-1], keyPoint);
			}
			_keyPoints.push(keyPoint);
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
		
		public function getLastLinkToPoint():LinkToPoint {
			if (_links && _links.length > 0) {
				return _links[_links.length-1];
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
		
		/* Internal functions */
		
		private function addLink(from:KeyPoint, to:KeyPoint):void {
			if (!_links) { _links = new Vector.<LinkToPoint>(); }
			_links.push(new LinkToPoint(from, to, _linksColor));
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
