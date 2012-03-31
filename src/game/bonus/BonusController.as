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

public class BonusController{
	private var _hunter:Hunter;
	private var _gameScene:GameScene;
	private var _bonusContainer:Sprite;
	private var _enemyArmyController:EnemyArmyController;
	private var _bonusList:Vector.<Bonus>;

	private const BONUS_FREQUENCY:Number = .3;

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
		for each (var bonus:Bonus in _bonusList) { bonus.tick(); }
		createBonusByFrequency();
		checkHitTestHero();

	}

	private function createBonusByFrequency():void {
		var needCreate:Boolean = Math.random() < BONUS_FREQUENCY/100;
		if (needCreate) {
			var aBonus:Bonus = Bonus.createRandomBonus();
			aBonus.addEventListener(BonusEvent.REMOVE_ME, onBonusRemoveRequest);
			addBonus(aBonus);
			_bonusContainer.addChild(aBonus);
		}
	}

	private function addBonus(aBonus:Bonus) {
		if (!_bonusList) { _bonusList = new Vector.<Bonus>(); }
		_bonusList.push(aBonus);
	}

	private function checkHitTestHero():void {
		if (!_bonusList) { return; }
		for (var i:int = 0; i < _bonusList.length; ++i) {
			if (_bonusList[i].hitTestObject(_hunter)) {
				if (_bonusList[i].type == Bonus.FAST_THROW) {
					_bonusList[i].activate();
				}
				break;
			}
		}
	}

	private function onBonusRemoveRequest(event:BonusEvent):void {
		var bonus:Bonus = event.target as Bonus;
		bonus.deactivate();
		removeBonus(bonus);
	}

	private function removeBonus(bonus:Bonus):void {
		if (_bonusContainer.contains(bonus)) { _bonusContainer.removeChild(bonus); }
		var index:int = _bonusList.indexOf(bonus);
		if (index != -1) { _bonusList.splice(index, 1); }
	}

}
}
