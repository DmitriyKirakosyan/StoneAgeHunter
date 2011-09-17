package game.player {
	import animation.IcSprite;
	import flash.display.BitmapData;
	import tilemap.SharedBitmapHolder;
	import com.greensock.easing.Linear;
	import com.greensock.TimelineMax;
	import flash.geom.Point;
	import com.greensock.TweenLite;
	import flash.display.Sprite;

	public class Hunter extends IcSprite {
		private var _view:Sprite;
		private const moveTextureUrl:String = "animations/walk/walk";
		private const breatheTextureUrl:String = "animations/stay/breathe";
		
		private var _numStones:int;
		private var _speed:Number;
		private var _path:Vector.<Point>;
		private var _pathTimeline:TimelineMax;
		private var _moving:Boolean;
		
		private const ANIMATE_MOVE:String = "move";
		private const ANIMATE_STAY:String = "stay";
		
		public function Hunter() {
			super();
			_speed = 1;
			_moving = false;
			_view = new Sprite;
			this.scaleX = .5;
			this.scaleY = .5;
			addChild(_view);
			addFrames();
			play(ANIMATE_STAY);
		}
		
		/* API */
		
		public function get speed():Number { return _speed; }
		public function set speed(value:Number):void {
			_speed = value;
		}
		
		public function castStone():void {
			_numStones = _numStones > 0 ? _numStones - 1 : 0;
		}
		
		public function get path():Vector.<Point> {
			return _path;
		}
		
		public function remove():void {
			removeChild(_view);
			_view = null;
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
		
		public function move():void {
			if (_pathTimeline && _path) { trace("path length : ", _path.length); play(ANIMATE_MOVE); _pathTimeline.play(); }
		}
		
		public function pauseMove():void {
			if (_pathTimeline) { play(ANIMATE_STAY); _pathTimeline.pause(); }
		}
/*		
		public function followPath(path:Vector.<Point>):void {
			if (!path || path.length == 0) { return; }
			_moving = true;
			_pathTimeline = new TimelineMax();
			for each (var point:Point in path) {
				_pathTimeline.append(new TweenLite(this, .9, {x : point.x-this.width/2, y : point.y-this.height/2,
																						ease : Linear.easeNone,
																						onStart : onStartPoint}));
			}
		}
		 * 
		 */
		
		/* Internal functions */
		
		private function addFrames():void {
			var bitmapList:Vector.<BitmapData> = new Vector.<BitmapData>();
			var nulls:String;
				//_view.addChild(new Bitmap(bitmap));
			var i:int;
			for (i = 1; i < 24; ++i) {
				nulls = i/10 < 1 ? "000" : "00";
				bitmapList.push(SharedBitmapHolder.instance.getTileByName(moveTextureUrl, "CaveMan"+ nulls + i + ".png"));
			}
			//bitmapList.reverse();
			addAnimation(ANIMATE_MOVE, 0, bitmapList);
			bitmapList = new Vector.<BitmapData>();
			for (i = 1; i < 38; ++i) {
				nulls = i/10 < 1 ? "000" : "00";
				bitmapList.push(SharedBitmapHolder.instance.getTileByName(breatheTextureUrl, "CaveManBreathe"+ nulls + i + ".png"));
			}
			addAnimation(ANIMATE_STAY, 0, bitmapList);
		}
		
		private function stopMove():void {
			_path = null;
			play(ANIMATE_STAY);
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
