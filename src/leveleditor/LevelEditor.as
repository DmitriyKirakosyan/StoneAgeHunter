/**
 * User: Dmitry
 * Date: 10/22/11
 * Time: 9:13 PM
 */
package leveleditor {
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Point;

public class LevelEditor {
	private var _container:Sprite;
	private var _panel:LevelEditorPanel;

	public function LevelEditor(container:Sprite, position:Point) {
		super();
		_container = container;
		_panel = new LevelEditorPanel();
		_panel.x = position.x;
		_panel.y = position.y;
		_panel.closeBtn.addEventListener(MouseEvent.CLICK, onCloseBtnClick);
	}

	public function open():void {
		_container.addChild(_panel);
	}

	public function close():void {
		_container.removeChild(_panel);
	}

	/* Internal functions */

	private function onCloseBtnClick(event:MouseEvent):void {
		close();
	}
}
}
