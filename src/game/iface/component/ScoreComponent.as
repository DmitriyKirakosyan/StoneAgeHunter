package game.iface.component {
import com.greensock.TweenMax;
import com.greensock.easing.Linear;

/**
	 * ...
	 * @author Dima
	 */
public class ScoreComponent extends ScoreView {

	public function ScoreComponent() {
		super();
		this.scoreText.text = "0";
		this.scoreText.selectable = false;
		this.scoreText.mouseEnabled = false;
	}

	public function setScore(value:int):void {
		this.scoreText.text = value.toString();
		if (value != 0) {
			pulseSkull();
		}
	}

	private function pulseSkull():void {
		TweenMax.to(this.skull, .1, {scaleX:1.2, scaleY:1.2, ease:Linear.easeNone, onComplete:onScaleUpSkullComplete
		});
	}

	private function onScaleUpSkullComplete():void {
		TweenMax.to(this.skull, .1, {scaleX:1, scaleY:1, ease:Linear.easeNone});
	}

}

}