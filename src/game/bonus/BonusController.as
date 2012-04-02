/**
 * Created by IntelliJ IDEA.
 * User: dima
 * Date: 3/10/12
 * Time: 10:57 AM
 * To change this template use File | Settings | File Templates.
 */
package game.bonus {
import flash.display.Sprite;

import game.GameScene;
import game.enemy.EnemyArmyController;
import game.player.Hunter;
import game.pointer.HiddenObjectPointer;

public class BonusController{
	private var _hunter:Hunter;
	private var _gameScene:GameScene;
	private var _bonusContainer:Sprite;
	private var _enemyArmyController:EnemyArmyController;
	private var _bonusList:Vector.<Bonus>;

	private const BONUS_FREQUENCY:Number = .2;

	public function BonusController(hunter:Hunter, gameScene:GameScene, enemyArmyController:EnemyArmyController) {
		_hunter = hunter;
		_gameScene = gameScene;
		_enemyArmyController = enemyArmyController;
		_bonusContainer = new Sprite();
	}

	public function open():void {
		_gameScene.gameContainer.addChild(_bonusContainer);
	}
	public function close():void {
		_gameScene.gameContainer.removeChild(_bonusContainer);
	}

	public function tick():void {
		var removedBonuses:Vector.<Bonus>;
		for each (var bonus:Bonus in _bonusList) {
			bonus.tick();
			if (bonus.removed) {
				if (!removedBonuses) { removedBonuses = new Vector.<Bonus>(); }
				removedBonuses.push(bonus);
			}
			updateBonusPointers(bonus);
		}
		for each (var removedBonus:Bonus in removedBonuses) {
			removeBonus(removedBonus);
		}
		createBonusByFrequency();
		checkHitTestHero();
	}

	private function updateBonusPointers(bonus:Bonus):void {
		if (bonus.x + _gameScene.gameContainer.x < 0 || bonus.y + _gameScene.gameContainer.y < 0 ||
				bonus.x + _gameScene.gameContainer.x > Main.WIDTH || bonus.y + _gameScene.gameContainer.y > Main.HEIGHT) {
			bonus.directionPointer.updatePosition();

			if (!_gameScene.pointersContainer.contains(bonus.directionPointer)) {
				trace("add pointer");
				_gameScene.pointersContainer.addChild(bonus.directionPointer);
			}
		} else {
			if (_gameScene.pointersContainer.contains(bonus.directionPointer)) {
				_gameScene.pointersContainer.removeChild(bonus.directionPointer);
			}
		}

	}

	private function createBonusByFrequency():void {
		var needCreate:Boolean = Math.random() < BONUS_FREQUENCY/100;
		if (needCreate) {
			trace("need create bonus");
			var aBonus:Bonus = Bonus.createFastThrowBonus(_hunter);
			aBonus.addPointer(HiddenObjectPointer.createBonusPointer(Main.WIDTH, Main.HEIGHT, aBonus, _hunter, _gameScene.gameContainer));
			addBonus(aBonus);
			aBonus.x = Math.random() * GameScene.WIDTH;
			aBonus.y = Math.random() * GameScene.HEIGHT;
			_bonusContainer.addChild(aBonus);
		}
	}

	private function addBonus(aBonus:Bonus) {
		if (!_bonusList) { _bonusList = new Vector.<Bonus>(); }
		trace("add bonus [BonusController.addBonus]");
		_bonusList.push(aBonus);
	}

	private function checkHitTestHero():void {
		if (!_bonusList) { return; }
		for (var i:int = 0; i < _bonusList.length; ++i) {
			if (_bonusList[i].hitTestObject(_hunter)) {
				if (_bonusList[i].type == Bonus.FAST_THROW) {
					_bonusList[i].activate();
					if (_bonusContainer.contains(_bonusList[i])) { _bonusContainer.removeChild(_bonusList[i]); }
				}
				break;
			}
		}
	}

	private function removeBonus(bonus:Bonus):void {
		if (_bonusContainer.contains(bonus)) { _bonusContainer.removeChild(bonus); }
		trace("try remove bonus");
		if (_gameScene.pointersContainer.contains(bonus.directionPointer)) {
			trace("try remove bonus pointer");
			_gameScene.pointersContainer.removeChild(bonus.directionPointer);
		}
		var index:int = _bonusList.indexOf(bonus);
		if (index != -1) { _bonusList.splice(index, 1); trace("remove bonus from list, length : " + _bonusList.length + " [BonusController.removeBonus"); }
	}

}
}
