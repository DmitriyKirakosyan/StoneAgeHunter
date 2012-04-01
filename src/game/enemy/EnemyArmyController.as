/**
 * User: dima
 * Date: 21/03/12
 * Time: 3:04 PM
 */
package game.enemy {
import com.greensock.TweenLite;

import flash.events.EventDispatcher;

import flash.text.TextField;
import flash.text.TextFormat;

import game.GameScene;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

import game.animal.AnimalEvent;

import game.animal.Duck;
import game.armor.Stone;
import game.player.Hunter;

import utils.BeenzaBouncer;

public class EnemyArmyController extends EventDispatcher {
	private var _duckList:Vector.<Duck>;
	private var _gameContainer:Sprite;
	private var _pointersContainer:Sprite;
	private var _hunter:Hunter;

	private var _enemyCreateCounter:Number;
	
	private var _killedNum:int;

	private var _enemyCreateTimeout:Number;
	private var _enemySpeed:Number;

	private const ENEMY_SPEED_MAX:Number = 2;
	private const ENEMY_CREATE_TIMEOUT_MIN:Number = .5;

	public function EnemyArmyController(gameContainer:Sprite, pointersContainer:Sprite,  hunter:Hunter) {
		super();
		_killedNum = 0; 
		_gameContainer = gameContainer;
		_pointersContainer = pointersContainer;
		_hunter = hunter;
	}

	public function open():void {
		_enemyCreateTimeout = 2;
		_enemySpeed = .5;
		_enemyCreateCounter = 0;
		_gameContainer.addChild(BeenzaBouncer.instance);
		_gameContainer.addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	public function close():void {
		_gameContainer.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		_gameContainer.removeChild(BeenzaBouncer.instance);
		for each (var duck:Duck in _duckList) {
			if (_gameContainer.contains(duck)) {
				_gameContainer.removeChild(duck);
			}
		}
		_killedNum = 0;
	}
	
	public function get killedNum():int { return _killedNum; }

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

	public function checkDamageDuck(stones:Vector.<Stone>):Boolean {
		for each (var duck:Duck in _duckList) {
			for each (var stone:Stone in stones) {
				if (stone.flying) {
					if (duck.hitTestObject(stone)) {
						killDuck(duck);
						stone.stopFly();
						return true;
					}
				}
			}
		}
		return false;
	}
	
	public function checkHitHunter():Boolean {
		for each (var duck:Duck in _duckList) {
			if (Math.abs(duck.x - _hunter.x) < 10 && Math.abs(duck.y - _hunter.y) < 10) {
				return true;
			}
		}
		return false;
	}

	/* Internal functions */

	private function onEnterFrame(event:Event):void {
		_enemyCreateCounter += 1/Main.FRAME_RATE;
		if (_enemyCreateCounter >= _enemyCreateTimeout) {
			createDuck();
			_enemyCreateCounter = 0;
		}

		updateOfflineDuckPointers();
	}

	private function killDuck(duck:Duck):void {
		var index:int = _duckList.indexOf(duck);
		if (index != -1) { _duckList.splice(index, 1); }
		duck.dead();
		if (_pointersContainer.contains(duck.directionPointer)) {
			_pointersContainer.removeChild(duck.directionPointer);
			if (_gameContainer.contains(duck)) { _gameContainer.removeChild(duck); }
		} else {
			TweenLite.to(duck, 1, {alpha:0, onComplete:function():void {
				if (_gameContainer.contains(duck)) { _gameContainer.removeChild(duck); }
			}
			});
			//shot +1
			const txtFormat:TextFormat = new TextFormat("PFAgoraSlabPro-Black", 16,
														0x78B449, null, null, null, "", "", "center", 0, 0, 0, 0);
			const txt:TextField = BeenzaBouncer.instance.createBounceTextField("+1", txtFormat);
			BeenzaBouncer.instance.bounceTxtAtPoint(txt, new Point(duck.x-(txt.width/2), duck.y-10));
		}

		_killedNum++;

		updateDifficult();

		dispatchEvent(new EnemyArmyEvent(EnemyArmyEvent.ENEMY_KILLED));
	}

	private function updateOfflineDuckPointers():void {
		for each (var duck:Duck in _duckList) {
			if (duck.x + _gameContainer.x < 0 || duck.y + _gameContainer.y < 0 ||
					duck.x + _gameContainer.x > Main.WIDTH || duck.y + _gameContainer.y > Main.HEIGHT) {

				duck.updateDirectionPointer(getSideForOfflineDuckPointer(duck));
				//duck.directionPointer.x -= _gameContainer.x;
				//duck.directionPointer.y -= _gameContainer.y;
				if (!_pointersContainer.contains(duck.directionPointer)) { _pointersContainer.addChild(duck.directionPointer); }
			} else {
				if (_pointersContainer.contains(duck.directionPointer)) { _pointersContainer.removeChild(duck.directionPointer); }
			}
		}
	}

	private function getSideForOfflineDuckPointer(duck:Duck):uint {
		var result:uint;
		if (duck.x + _gameContainer.x < 0) {
			result = EnemyDirectionPointer.LEFT_SIDE;
		}
		if (duck.y + _gameContainer.y < 0) {
			if (result == EnemyDirectionPointer.LEFT_SIDE) {
				if (duck.y + _gameContainer.y < duck.x + _gameContainer.x) {
					result = EnemyDirectionPointer.TOP_SIDE;
				}
			} else {
				result = EnemyDirectionPointer.TOP_SIDE;
			}
		}
		if (duck.x + _gameContainer.x > Main.WIDTH) {
			if (result == EnemyDirectionPointer.TOP_SIDE) {
				if ((duck.x + _gameContainer.x) - Main.WIDTH > -duck.y - _gameContainer.y ) {
					result = EnemyDirectionPointer.RIGHT_SIDE;
				}
			} else { result = EnemyDirectionPointer.RIGHT_SIDE; }
		}
		if (duck.y + _gameContainer.y > Main.HEIGHT) {
			if (result == EnemyDirectionPointer.LEFT_SIDE) {
				if ((duck.y + _gameContainer.y)-Main.HEIGHT > -duck.x - _gameContainer.x) {
					result = EnemyDirectionPointer.BOTTOM_SIDE;
				}
			} else if (result == EnemyDirectionPointer.RIGHT_SIDE) {
				if ((duck.y + _gameContainer.y)-Main.HEIGHT > (duck.x + _gameContainer.x)-Main.WIDTH) {
					result = EnemyDirectionPointer.BOTTOM_SIDE;
				}
			} else { result = EnemyDirectionPointer.BOTTOM_SIDE; }
		}
		return result
	}

	private function updateDifficult():void {
		if (_enemyCreateTimeout > ENEMY_CREATE_TIMEOUT_MIN) {
			_enemyCreateTimeout -= .01;
		}
		if (_enemySpeed < ENEMY_SPEED_MAX) {
			_enemySpeed += .01;
		}
	}

	private function createDuck():void {
		var duck:Duck = new Duck(_enemySpeed);
		duck.directionPointer = new EnemyDirectionPointer(Main.WIDTH, Main.HEIGHT, duck, _hunter, _gameContainer);
		var side:uint = Math.random() * 4;
		if (side == 0 || side == 2) {
			duck.x = (side/2) * GameScene.HEIGHT;
		} else {
			duck.x = Math.random() * GameScene.WIDTH;
		}
		if (side == 1 || side == 3) {
			duck.y = (side-1)/2 * GameScene.WIDTH;
		} else {
			duck.y = Math.random() * GameScene.HEIGHT;
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
