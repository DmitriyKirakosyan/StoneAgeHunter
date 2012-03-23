package game.armor {
import animation.IcSprite;

import flash.display.Sprite;

import game.DecorativeObject;

public class Stone extends IcSprite {
	private var _flying:Boolean;
	private var _shadow:Sprite;

	public function Stone() {
		super();
		_flying = false;
		this.addChild(DecorativeObject.createLittleHill());
	}
	
	public function get shadow():Sprite { return _shadow; }

	public function get flying():Boolean {
		return _flying;
	}

	public function fly():void {
		_flying = true;
		createShadow();
	}
	public function stopFly(container:Sprite):void {
		_flying = false;
		removeShadow(container);
	}
	
	private function createShadow():void {
			_shadow = new Sprite();
			_shadow.graphics.beginFill(0x000000, .2);
			_shadow.graphics.drawEllipse(0, 0, 12, 9);
			_shadow.graphics.endFill();
			//shadow.filters = [new BlurFilter()];
			_shadow.x = x;
			_shadow.y = y;
	}
	
	public function removeShadow(container:Sprite):void {
		if (container.contains(_shadow)) { container.removeChild(_shadow); }
		_shadow = null;
	}

	private function draw():void {
		this.graphics.beginFill(0x0fafcd);
		this.graphics.drawCircle(0, 0, 5);
		this.graphics.endFill();
	}

}
}
