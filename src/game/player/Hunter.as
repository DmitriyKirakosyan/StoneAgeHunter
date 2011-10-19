package game.player {
	import animation.IcSprite;
	
	import flash.display.BitmapData;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	
	import game.HpLine;
	import game.armor.Stone;
	import game.gameActor.IcActer;

	public class Hunter extends IcActer {
		private var _hp:HpLine;
		
		private var _stone:Stone;
		
		private var _baseColor:uint;
		
		private var _debug:Boolean;
		
		public function Hunter(debug:Boolean) {
			super();
			_debug = debug;
			_baseColor = Math.random() * 0xffffff;
			path.setLinksColor(_baseColor);
			this.scaleX = .3;
			this.scaleY = .3;
			_hp = new HpLine(2);
			_hp.y = -20;
			addChild(_hp);
			addAnimations();
			play(ANIMATE_STAY);
		}
		
		/* API */
		
		public function get hp():Number { return _hp.value; }
		public function set hp(value:Number):void {
			_hp.value = value;
		}
		
		public function damage(value:Number = 1):void {
			_hp.damage(value);
		}
		
		public function get hasStone():Boolean {
			return _stone != null;
		}
		
		public function putStone(stone:Stone):void {
			_stone = stone;
			stone.x = 150;
			stone.y = 50;
			this.addChild(stone);
		}
		
		override public function getAlternativeCopy(copyName:String=""):IcSprite {
			if (copyName == "") {
				const res:IcSprite = new IcSprite();
				res.graphics.beginFill(0xafafaf);
				res.graphics.drawRect(this.x, this.y, this.width, this.height);
				res.graphics.endFill();
				return res;
			}
			return this;
		}
		
		public function startFollowPath():void {
			removePrevTween();
		}
		
		override public function addWayPoint(point:Point):void {
			super.addWayPoint(point);
			move();
		}
		
		override public function move():void {
			super.move();
			if (pathTimeline && path) { play(ANIMATE_MOVE);}
		}
		
		override protected function stop():void {
			super.stop();
			play(ANIMATE_STAY);
		}
		
		override public function pauseMove():void {
			super.pauseMove();
			if (pathTimeline) { play(ANIMATE_STAY); }
		}
		
		public function onClick():void {
			startPath(new Point(this.x, this.y));
			filters = [new GlowFilter(_baseColor)];
		}
		public function unselect():void {
			filters = [];
		}
		
		/* Internal functions */
		
		private function addAnimations():void {
			addAnimation(ANIMATE_STAY, new ManStayD(), new ManStayU());
			addAnimation(ANIMATE_MOVE, new ManRunD(), new ManRunU());
		}
		
	}
}
