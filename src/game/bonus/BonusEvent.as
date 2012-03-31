/**
 * Created by IntelliJ IDEA.
 * User: dima
 * Date: 3/31/12
 * Time: 10:03 AM
 * To change this template use File | Settings | File Templates.
 */
package game.bonus {
import flash.events.Event;

public class BonusEvent extends Event {

	public static const REMOVE_ME:String = "removeMe";

	public function BonusEvent(type:String) {
		super(type);
	}
}
}
