/**
 * User: Dmitry
 * Date: 10/22/11
 * Time: 9:15 PM
 */
package leveleditor {
import com.bit101.components.PushButton;

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.BlurFilter;
import flash.filters.GlowFilter;

public class LevelEditorPanel extends Sprite{
	private var _freeTileBtn:Sprite;
	private var _lockedTileBtn:Sprite;

	private var _closeBtn:PushButton;

	public function LevelEditorPanel() {
		super();
		createTileBtns();
		createBtns();
	}

	public function get closeBtn():PushButton { return _closeBtn; }

	private function createTileBtns():void {
		_freeTileBtn = new Sprite();
		_freeTileBtn.addChild(new GroundM());
		_freeTileBtn.filters = [new GlowFilter()];
		_freeTileBtn.x = 150;
		_freeTileBtn.y = 20;
		_lockedTileBtn = new Sprite();
		_lockedTileBtn.addChild(new GroundM());
		_lockedTileBtn.filters = [new GlowFilter(), new BlurFilter()];
		_lockedTileBtn.x = 250;
		_lockedTileBtn.y = 20;
		_freeTileBtn.addEventListener(MouseEvent.MOUSE_DOWN, onTileBtnMouseDown);
		_lockedTileBtn.addEventListener(MouseEvent.MOUSE_DOWN, onTileBtnMouseDown);

		trace("[LevelEditorPanel.createTileBtns] tiles created");
		addChild(_freeTileBtn);
		addChild(_lockedTileBtn);
	}

	private function createBtns():void {
		_closeBtn = new PushButton(this, 10, 10, "close");
	}

	private function onTileBtnMouseDown(event:MouseEvent):void {
		trace("tile mouse down");
	}
}
}
