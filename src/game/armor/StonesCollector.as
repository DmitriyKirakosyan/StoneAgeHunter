/**
 * Created by : Dmitry
 * Date: 3/26/12
 * Time: 10:58 PM
 */
package game.armor {
import flash.display.Sprite;

public class StonesCollector {
	private var _stones:Vector.<Stone>;
	private var _container:Sprite;

	public function StonesCollector(container:Sprite) {
		_container = container;
	}

	public function get stones():Vector.<Stone> { return _stones; }

	public function addStone(stone:Stone):void {
		stone.addEventListener(StoneEvent.STOP_FLY, onStoneStopFly);
		_container.addChild(stone);
		if (!_stones) { _stones = new Vector.<Stone>(); }
		_stones.push(stone);
	}

	public function removeStone(stone:Stone):void {
		trace("remove stone");
		var index:int = _stones.indexOf(stone);
		if (index != -1) {
			_stones.splice(index, 1);
		}
		if (_container.contains(stone)) { _container.removeChild(stone); }
	}

	/* Internal functions */

	private function onStoneStopFly(event:StoneEvent):void {
		var stone:Stone = event.target as Stone;
		stone.removeEventListener(StoneEvent.STOP_FLY, onStoneStopFly);
		stone.breakOnStones();
		//removeStone(stone);
	}
}
}
