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
public class ScoreComponent extends Sprite {
	private var _scoreText:TextField;
	private var _killedDuck:DeadDuckView;

	public function ScoreComponent() {
		super();
		this.x = Main.WIDTH - 100;
		this.y = 30;
		_killedDuck = new DeadDuckView();
		_killedDuck.scaleX = _killedDuck.scaleY = .3;
		_killedDuck.x = 60;
		createTextField();
		_scoreText.text = "0";
		this.addChild(_scoreText);
		this.addChild(_killedDuck);
	}

	public function setScore(value:int):void {
		_scoreText.text = value.toString();
	}

	private function createTextField():void {
		_scoreText = new TextField();
		_scoreText.selectable = false;
		_scoreText.mouseEnabled = false;
		_scoreText.autoSize = TextFieldAutoSize.LEFT;
		const txtFormat:TextFormat = new TextFormat("PFAgoraSlabPro-Black", 16,
													0x78B449, null, null, null, "", "", "center", 0, 0, 0, 0);
		_scoreText.defaultTextFormat = txtFormat;
	}

}

}