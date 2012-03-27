/**
 * Created by : Dmitry
 * Date: 3/28/12
 * Time: 12:33 AM
 */
package game.enemy {
import flash.events.Event;

public class EnemyArmyEvent extends Event {

	public static const ENEMY_KILLED:String = "enemyKilled";

	public function EnemyArmyEvent(type:String) {
		super(type);
	}
}
}
