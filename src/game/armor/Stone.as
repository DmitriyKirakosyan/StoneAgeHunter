package game.armor {
import animation.IcSprite;
import flash.events.MouseEvent;
import flash.filters.GlowFilter;

import com.greensock.TimelineMax;

import com.greensock.TweenLite;

import com.greensock.TweenMax;
import com.greensock.easing.Linear;

import flash.display.Sprite;
import flash.geom.Point;

public class Stone extends IcSprite {
	private var _flying:Boolean;
	private var _shadow:Sprite;
	private var _shadowContainer:Sprite;

	public function Stone(shadowContainer:Sprite):void {
		super();
		_flying = false;
		_shadowContainer = shadowContainer;
		this.addChild(new StoneView());
		addListeners();
	}
	
	public function remove():void {
		removeListeners();
	}
	
	public function get shadow():Sprite { return _shadow; }

	public function get flying():Boolean {
		return _flying;
	}

	public function fly(toPoint:Point):void {
		_flying = true;
		createShadow();
		var distance:Number = Point.distance(new Point(x, y), toPoint);
		TweenMax.to(this, distance/100,
						{bezier:[{x:x + (toPoint.x-x)/2, y:y-(y-toPoint.y)/2 - distance/2},
							{x : toPoint.x, y : toPoint.y } ], onComplete:onStoneFlyComplete, ease:Linear.easeNone});

		_shadowContainer.addChildAt(_shadow, 0);
		TweenLite.to(_shadow, distance / 100, { x: toPoint.x,  y:toPoint.y, ease:Linear.easeNone } );
		var timeline:TimelineMax = new TimelineMax();
		timeline.append(new TweenLite(_shadow, distance / 200, { scaleX:.6, scaleY:.6 } ));
		timeline.append(new TweenLite(_shadow, distance / 200, { scaleX:1, scaleY:1 } ));
	}
	public function stopFly():void {
		_flying = false;
		TweenMax.killTweensOf(this);
		removeShadow(_shadowContainer);
		dispatchEvent(new StoneEvent(StoneEvent.STOP_FLY));
	}
	
	private function addListeners():void {
		this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
	}
	
	private function removeListeners():void {
		this.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		this.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
	}
	
	private function onStoneFlyComplete():void {
		stopFly();
	}

	private function createShadow():void {
			_shadow = new Sprite();
			_shadow.graphics.beginFill(0x000000, .2);
			_shadow.graphics.drawEllipse(0, 0, 12, 9);
			_shadow.graphics.endFill();
			_shadow.x = x;
			_shadow.y = y;
	}
	
	public function removeShadow(container:Sprite):void {
		TweenMax.killTweensOf(shadow);
		if (container.contains(_shadow)) { container.removeChild(_shadow); }
		_shadow = null;
	}

	private function draw():void {
		this.graphics.beginFill(0x0fafcd);
		this.graphics.drawCircle(0, 0, 5);
		this.graphics.endFill();
	}
	
	private function onMouseOver(event:MouseEvent):void {
		this.filters = [new GlowFilter(0x000000)];
		trace("mouse over");
	}
	
	private function onMouseOut(event:MouseEvent):void {
		this.filters = [];
	}

}
}
