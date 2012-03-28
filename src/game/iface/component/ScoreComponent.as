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
	private var _background:Sprite;

	public function ScoreComponent() {
		super();
		this.x = Main.WIDTH - 100;
		this.y = 30;
		_killedDuck = new DeadDuckView();
		_killedDuck.scaleX = _killedDuck.scaleY = .3;
		_killedDuck.x = 70;
		_killedDuck.filters = [new GlowFilter(0xffffff, 1, 5, 5, 1)]
		createTextField();
		_scoreText.text = "0";
		createBackground();
		this.addChild(_background);
		this.addChild(_scoreText);
		this.addChild(_killedDuck);
	}

	public function setScore(value:int):void {
		_scoreText.text = value.toString();
	}

	private function createBackground():void {
		_background = new Sprite();
		_background.graphics.beginFill(0x040404, .6);
		_background.graphics.lineStyle(1, 0x000000);
		_background.graphics.drawRect(-10, -30, 100, 60);
		_background.graphics.endFill();
	}

	private function createTextField():void {
		_scoreText = new TextField();
		_scoreText.selectable = false;
		_scoreText.mouseEnabled = false;
		_scoreText.autoSize = TextFieldAutoSize.LEFT;
		const txtFormat:TextFormat = new TextFormat("PFAgoraSlabPro-Black", 18,
													0x78B449, null, null, null, "", "", "center", 0, 0, 0, 0);
		_scoreText.defaultTextFormat = txtFormat;
	}

}

}