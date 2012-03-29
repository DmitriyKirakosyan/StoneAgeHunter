package game.player {
	import animation.IcSprite;

import flash.display.Sprite;

import flash.filters.GlowFilter;
	import flash.geom.Point;
	
	import game.player.HpLine;
	import game.armor.Stone;
	import game.gameActor.IcActor;
import game.gameActor.IcActerEvent;
import game.player.HunterAnimationBuilder;
import game.player.HunterAnimationBuilder;

public class Hunter extends IcActor {
		private var _pathParts:Vector.<Sprite>;

		/* hitpoints line */
		private var _hp:HpLine;
		
		/* hunter's color of glow and path */
		private var _baseColor:uint;

		private var _throwTimeoutCounter:Number;
		private const THROW_TIMEOUT:int = 2;
		private var _canThrow:Boolean;

		private var _debug:Boolean;
		
		public function Hunter(debug:Boolean) {
			super();
			_throwTimeoutCounter = 0;
			_canThrow = false;
			_debug = debug;
			_baseColor = Math.random() * 0xffffff;
			path.setLinksColor(_baseColor);
			setScale(.18);
			_hp = new HpLine(2);
			_hp.y = -20;
			addAnimations();
			play(HunterAnimationBuilder.ANIMATION_STAY);
		}
		
		/* API */

		public function tick():void {
			if (_canThrow) { return; }
			_throwTimeoutCounter += 1/Main.FRAME_RATE;
			if (_throwTimeoutCounter >= THROW_TIMEOUT) {
				_canThrow = true;
				_throwTimeoutCounter = 0;
			}
		}

		// for debug
		public function setScale(value:Number):void {
			animationScale = value;
		}
		
		public function get hp():Number { return _hp.value; }
		public function set hp(value:Number):void {
			_hp.value = value;
		}

		//for debug
		public function get hpBar():Sprite { return _hp; }

		public function get baseColor():uint { return _baseColor; }
		
		public function damage(value:Number = 1):void {
			_hp.damage(value);
		}
		
		public function get canThrowStone():Boolean {
			return _canThrow;
		}
		
		public function throwStone(throwUpSide:Boolean):void {
			play(HunterAnimationBuilder.ANIMATION_THROW, throwUpSide);
			_canThrow = false;
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
			trace("[Hunter.startFollowPath]");
			removePrevTween();
			move();
		}

		public function get pathParts():Vector.<Sprite> { return _pathParts; }

		override public function move():void {
			super.move();
			play(HunterAnimationBuilder.ANIMATION_MOVE);
		}
		
		override public function stop():void {
			play(HunterAnimationBuilder.ANIMATION_STAY);
		}

		override protected function onStartTween(point:Point):void {
			play(HunterAnimationBuilder.ANIMATION_MOVE);
			super.onStartTween(point);
		}
		
		override public function pauseMove():void {
			super.pauseMove();
			if (pathTimeline) { play(HunterAnimationBuilder.ANIMATION_STAY); }
		}
		
		/* Internal functions */
		
		private function addAnimations():void {
			var animationBuilder:HunterAnimationBuilder = new HunterAnimationBuilder();
			addAnimation(animationBuilder.createStayAnimation());
			addAnimation(animationBuilder.createMoveAnimation());
			addAnimation(animationBuilder.createThrowAnimation());
		}
		
	}
}
