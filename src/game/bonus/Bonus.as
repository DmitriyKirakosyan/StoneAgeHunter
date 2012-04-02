/**
 * Created by IntelliJ IDEA.
 * User: dima
 * Date: 3/10/12
 * Time: 11:39 AM
 * To change this template use File | Settings | File Templates.
 */
package game.bonus {
import flash.display.Sprite;

import game.player.Hunter;
import game.pointer.HiddenObjectPointer;

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
	private var _removed:Boolean;

	private var _directionPointer:HiddenObjectPointer;

	public static function createFastThrowBonus(hunter:Hunter):Bonus {
		var result:Bonus = new FastThrowBonus(hunter);
		return result;
	}

	public function Bonus(type:uint) {
		_type = type;
		_waitTime = 15;
		_waitTimeCounter = 0;
		_effectTime = 10;
		_effectTimeCounter = 0;
		_active = false;
		_removed = false;
		init();
		createSprite();
	}

	public function addPointer(value:HiddenObjectPointer):void {
		_directionPointer = value;
	}

	public function get directionPointer():HiddenObjectPointer { return _directionPointer; }
	public function get removed():Boolean { return _removed; }

	public function tick():void {
		if (!_active) {
			_waitTimeCounter += 1/Main.FRAME_RATE;
			if (_waitTimeCounter >= _waitTime) {
				_removed = true;
				//dispatchEvent(new BonusEvent(BonusEvent.REMOVE_ME));
			}
		} else {
			_effectTimeCounter += 1/Main.FRAME_RATE;
			if (_effectTimeCounter >= _effectTime) {
				deactivate();
				_removed = true;
				//dispatchEvent(new BonusEvent(BonusEvent.REMOVE_ME));
			}
		}

	}

	protected function makeEffect():void {}

	protected function removeEffect():void {}

	public function activate():void {
		if (!_active) {
			_active = true;
			makeEffect();
		}
	}
	public function deactivate():void {
		if (_active) {
			removeEffect();
			_active = false;
		}
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
