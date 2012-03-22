package game.armor {
import animation.IcSprite;

import flash.display.Sprite;

import game.DecorativeObject;

public class Stone extends IcSprite {
	private var _flying:Boolean;

	public function Stone() {
		super();
		_flying = false;
		this.addChild(DecorativeObject.createLittleHill());
	}

	public function get flying():Boolean {
		return _flying;
	}

	public function fly():void {
		_flying = true;
	}
	public function stopFly():void {
		_flying = false;
	}

	private function draw():void {
		this.graphics.beginFill(0x0fafcd);
		this.graphics.drawCircle(0, 0, 5);
		this.graphics.endFill();
	}

}
}
