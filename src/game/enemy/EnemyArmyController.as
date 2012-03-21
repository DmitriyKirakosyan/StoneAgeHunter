/**
 * User: dima
 * Date: 21/03/12
 * Time: 3:04 PM
 */
package game.enemy {
import flash.display.Sprite;
import flash.events.Event;

import game.animal.Duck;
import game.player.Hunter;

public class EnemyArmyController {
	private var _duckList:Vector.<Duck>;
	private var _gameContainer:Sprite;
	private var _hunter:Hunter;

	private var _enemyCreateCounter:Number;

	private const ENEMY_CREATE_TIMEOUT:int = 2;

	public function EnemyArmyController(gameContainer:Sprite, hunter:Hunter) {
		super();
		_gameContainer = gameContainer;
		_hunter = hunter;
	}

	public function open():void {
		_enemyCreateCounter = 0;
		_gameContainer.addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	public function close():void {
		_gameContainer.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
	}

	/* Internal functions */

	private function onEnterFrame(event:Event):void {
		_enemyCreateCounter += 1/Main.FRAME_RATE;
		if (_enemyCreateCounter >= ENEMY_CREATE_TIMEOUT) {
			createDuck();
			_enemyCreateCounter = 0;
		}
	}

	private function createDuck():void {
		var duck:Duck = new Duck();
		var side:uint = Math.random() * 4;
		if (side == 0 || side == 2) {
			duck.x = (side/2) * Main.HEIGHT;
		} else {
			duck.x = Math.random() * Main.WIDTH;
		}
		if (side == 1 || side == 3) {
			duck.y = (side-1)/2 * Main.WIDTH;
		} else {
			duck.y = Math.random() * Main.HEIGHT;
		}
		duck.fasHunter(_hunter);
		//duck.move();
		_gameContainer.addChild(duck);
		addDuck(duck);
	}

	private function addDuck(duck:Duck):void {
		if (!_duckList) { _duckList = new Vector.<Duck>(); }
		_duckList.push(duck);
	}
}
}
