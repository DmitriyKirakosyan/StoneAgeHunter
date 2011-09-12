package game.player {
	import com.greensock.easing.Linear;
	import com.greensock.TimelineMax;
	import flash.geom.Point;
	import com.greensock.TweenLite;
	import flash.display.Sprite;

	public class Hunter extends Sprite {
		private var _view:Sprite;
		
		private var _path:Vector.<Point>;
		private var _pathTimeline:TimelineMax;
		private var _moving:Boolean;
		
		public function Hunter() {
			super();
			_moving = false;
			addImage();
		}
		
		/* API */
		
		public function remove():void {
			removeChild(_view);
			_view = null;
		}
		
		public function followPath(path:Vector.<Point>):void {
			if (!path || path.length == 0) { return; }
			_moving = true;
			_pathTimeline = new TimelineMax();
			for each (var point:Point in path) {
				_pathTimeline.append(new TweenLite(this, .9, {x : point.x-this.width/2, y : point.y-this.height/2,
																						ease : Linear.easeNone}));
			}
		}
		
		/* Internal functions */
		
		private function addImage():void {
			_view = new BricksView();
			addChild(_view);
		}
	}
}
