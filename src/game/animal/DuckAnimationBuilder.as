/**
 * User: dima
 * Date: 21/03/12
 * Time: 3:41 PM
 */
package game.animal {
import animation.IcAnimation;

public class DuckAnimationBuilder {
	public static const ANIMATION_MOVE:String = "move";
	public static const ANIMATION_STAY:String = "stay";
	public static const ANIMATION_HIT:String = "hit";

	public function DuckAnimationBuilder() {
	}

	public function createMoveAnimation():IcAnimation {
		return new IcAnimation(ANIMATION_MOVE, new DuckWalkD(), new DuckWalkU());
	}

	public function createStayAnimation():IcAnimation {
		return new IcAnimation(ANIMATION_STAY, new DuckStayD(), new DuckStayU());
	}

	public function createHitAnimation():IcAnimation {
		return new IcAnimation(ANIMATION_HIT, new DuckHitD(), new DuckHitU(), IcAnimation.PRIORITY_MEDIUM, false);
	}



}
}
