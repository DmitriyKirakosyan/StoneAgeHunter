/**
 * Created by IntelliJ IDEA.
 * User: dima
 * Date: 3/31/12
 * Time: 10:06 AM
 * To change this template use File | Settings | File Templates.
 */
package game.bonus {
import game.player.Hunter;

public class FastThrowBonus extends Bonus {
	private var _hunter:Hunter;
	private var _throwSpeed:int = 1;
	private var _decSpeedValue:Number;

	public function FastThrowBonus(hunter:Hunter) {
		super(Bonus.FAST_THROW);
		_hunter = hunter;
		if (_hunter.getMaxThrowSpeed() < _throwSpeed) { _throwSpeed = _hunter.getMaxThrowSpeed(); }
	}

	override protected function makeEffect():void {
		_decSpeedValue = _throwSpeed - _hunter.throwSpeed;
		if (_decSpeedValue > 0) {
			_hunter.incThrowSpeedOn(_decSpeedValue);
		} else {
			_decSpeedValue = 0;
		}
	}

	override protected function removeEffect():void {
		_hunter.decThrowSpeedOn(_decSpeedValue);
	}

	override public function tick():void {
		super.tick();

	}

	override protected function init():void {

	}
	override protected function createSprite():void {

	}
}
}
