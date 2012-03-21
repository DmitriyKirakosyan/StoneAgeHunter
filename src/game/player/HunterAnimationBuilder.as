/**
 * User: dima
 * Date: 21/03/12
 * Time: 2:34 PM
 */
package game.player {
import animation.IcAnimation;

import game.gameActor.ActorAnimationBuilder;

public class HunterAnimationBuilder extends ActorAnimationBuilder {

	public static const ANIMATION_THROW:String = "animation_throw";
	public static const ANIMATION_MOVE:String = "move";
	public static const ANIMATION_STAY:String = "stay";

	public function HunterAnimationBuilder() {
	}

	public function createThrowAnimation():IcAnimation {
		return new IcAnimation(ANIMATION_THROW, new ManThrowD(), new ManThrowU(), IcAnimation.PRIORITY_MEDIUM, true);
	}

	public function createMoveAnimation():IcAnimation {
		return new IcAnimation(ANIMATION_MOVE, new ManRunD(), new ManRunU());
	}

	public function createStayAnimation():IcAnimation {
		return new IcAnimation(ANIMATION_STAY, new ManStayD(), new ManStayU());
	}

}
}
