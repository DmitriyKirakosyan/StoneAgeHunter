package game.iface.component {
import flash.display.Sprite;
import flash.filters.GlowFilter;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;


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
	}

}

}