/**
 * Created by IntelliJ IDEA.
 * User: dima
 * Date: 3/10/12
 * Time: 11:39 AM
 * To change this template use File | Settings | File Templates.
 */
package game.bonus {
import flash.display.Sprite;

public class Bonus extends Sprite {

	public static var STOP_WORLD:uint = 0;
	public static var FAST_THROW:uint = 1;
	public static var DEFENCE:uint = 2;

	private var _type:uint;
	private var _effectTime:Number; //sec
	private var _effectTimeCounter:Number;
	private var _waitTime:Number;
	private var _waitTimeCounter:Number;
	private var _active:Boolean;

	public static function createRandomBonus():Bonus {
		var result:Bonus = new Bonus(Math.random() * 3);
		return result;
	}

	public function Bonus(type:uint) {
		_type = type;
		_waitTime = 5;
		_active = false;
		init();
		createSprite();
	}

	public function tick():void {
		if (!_active) {
			_waitTimeCounter += 1/Main.FRAME_RATE;
			if (_waitTimeCounter >= _waitTime) {
				dispatchEvent(new BonusEvent(BonusEvent.REMOVE_ME));
			}
		} else {
			_effectTimeCounter += 1/Main.FRAME_RATE;
			if (_effectTimeCounter >= _effectTime) {
				dispatchEvent(new BonusEvent(BonusEvent.REMOVE_ME));
			}
		}
	}

	protected function makeEffect():void {}

	protected function removeEffect():void {}

	public function activate():void {
		_active = true;
		makeEffect();
	}
	public function deactivate():void {
		_active = false;
		removeEffect();
	}
	public function get type():uint { return _type; }
	public function get effectTime():Number { return _effectTime}
	public function set effectTime(value:Number):void { _effectTime = value; }

	protected function init():void {
		_effectTime = 5;
	}
	protected function createSprite():void {
	}


}
}
