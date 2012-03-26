/**
 * Created by : Dmitry
 * Date: 3/26/12
 * Time: 11:05 PM
 */
package game.armor {
import flash.events.Event;

public class StoneEvent extends Event {

	public static const STOP_FLY:String = "stopFly";
	public function StoneEvent(type:String) {
		super(type);
	}
}
}
