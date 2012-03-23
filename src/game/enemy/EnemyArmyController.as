/**
 * User: dima
 * Date: 21/03/12
 * Time: 3:04 PM
 */
package game.enemy {
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

import game.animal.AnimalEvent;

import game.animal.Duck;
import game.armor.Stone;
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

	public function getDuckForShoot():Duck {
		if (!_duckList || _duckList.length == 0) { return null; }
		var result:Duck = _duckList[0];
		var currentMinDistance:Number = Point.distance(new Point(_hunter.x, _hunter.y), new Point(result.x, result.y));
		var tempDistance:Number;
		for each (var duck:Duck in _duckList) {
			tempDistance = Point.distance(new Point(_hunter.x, _hunter.y), new Point(duck.x, duck.y));
			if (tempDistance < currentMinDistance) {
				currentMinDistance = tempDistance;
				result = duck;
			}
		}
		return result;
	}

	public function checkDamageDuck(stones:Vector.<Stone>):void {
		for each (var duck:Duck in _duckList) {
			for each (var stone:Stone in stones) {
				if (stone.flying) {
					if (stone.hitTestObject(duck)) {
						killDuck(duck);
						return;
					}
				}
			}
		}
	}

	/* Internal functions */

	private function onEnterFrame(event:Event):void {
		_enemyCreateCounter += 1/Main.FRAME_RATE;
		if (_enemyCreateCounter >= ENEMY_CREATE_TIMEOUT) {
			createDuck();
			_enemyCreateCounter = 0;
		}
	}

	private function killDuck(duck:Duck):void {
		var index:int = _duckList.indexOf(duck);
		if (_gameContainer.contains(duck)) { _gameContainer.removeChild(duck); }
		duck.stopMoving();
		if (index != -1) { _duckList.splice(index, 1); }
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
		duck.addEventListener(AnimalEvent.FOLLOW_COMPLETE, onDuckFollowComplete);
		duck.fasHunter(_hunter);
		_gameContainer.addChild(duck);
		addDuck(duck);
	}
	
	private function onDuckFollowComplete(event:AnimalEvent):void {
		var duck:Duck = event.target as Duck;
		if (duck.x != _hunter.x && duck.y != _hunter.y) {
			duck.fasHunter(_hunter);
		}
	}

	private function addDuck(duck:Duck):void {
		if (!_duckList) { _duckList = new Vector.<Duck>(); }
		_duckList.push(duck);
	}
}
}
