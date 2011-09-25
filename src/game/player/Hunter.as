package game.player {
	import animation.IcSprite;
	import game.IcActer;
	import game.HpLine;
	import flash.display.BitmapData;
	import tilemap.SharedBitmapHolder;

	public class Hunter extends IcActer {
		private const moveTextureUrl:String = "animations/walk/walk";
		private const breatheTextureUrl:String = "animations/stay/breathe";
		
		private var _hp:HpLine;
		
		private const ANIMATE_MOVE:String = "move";
		private const ANIMATE_STAY:String = "stay";
		
		public function Hunter() {
			super();
			//this.scaleX = .5;
			//this.scaleY = .5;
			_hp = new HpLine(2);
			_hp.y = -20;
			addChild(_hp);
			addFrames();
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
		
		public function castStone():void {
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
		
		override public function move():void {
			super.move();
			if (pathTimeline && path) { play(ANIMATE_MOVE);}
		}
		
		override public function pauseMove():void {
			super.pauseMove();
			if (pathTimeline) { play(ANIMATE_STAY);}
		}
		
		/* Internal functions */
		
		private function addFrames():void {
			if (SharedBitmapHolder.existInCache(moveTextureUrl)) {
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
			}
			if (SharedBitmapHolder.existInCache(breatheTextureUrl)) {
				bitmapList = new Vector.<BitmapData>();
				for (i = 1; i < 38; ++i) {
					nulls = i/10 < 1 ? "000" : "00";
					bitmapList.push(SharedBitmapHolder.instance.getTileByName(breatheTextureUrl, "CaveManBreathe"+ nulls + i + ".png"));
				}
				addAnimation(ANIMATE_STAY, 0, bitmapList);
			}
		}
		
		override protected function stopMove():void {
			super.stopMove();
			play(ANIMATE_STAY);
		}

	}
}
