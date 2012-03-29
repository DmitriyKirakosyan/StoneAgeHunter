/**
 * User: dima
 * Date: 29/03/12
 * Time: 5:02 PM
 */
package game.enemy {
import flash.display.Sprite;

public class EnemyDirectionPointer extends Sprite {

	private var _side:uint;

	private var _hidedSprite:Sprite;
	private var _mainSprite:Sprite;
	private var _movingContainer:Sprite;

	private var _sceneWidth:int;
	private var _sceneHeight:int;

	public static const RIGHT_SIDE:uint = 0;
	public static const LEFT_SIDE:uint = 1;
	public static const TOP_SIDE:uint = 2;
	public static const BOTTOM_SIDE:uint = 3;

	public function EnemyDirectionPointer(sceneWidth:int, sceneHeight:int, hidedSprite:Sprite, mainSprite:Sprite, movingContainer:Sprite):void {
		_sceneHeight = sceneHeight;
		_sceneWidth = sceneWidth;
		_hidedSprite = hidedSprite;
		_mainSprite = mainSprite;
		_movingContainer = movingContainer;
		create();
	}

	public function get side():uint { return _side; }
	public function set side(value:uint):void { _side = value; }

	public function updatePosition(side:uint):void {
		if (side == RIGHT_SIDE || side == LEFT_SIDE) {
			//this.x = (side == RIGHT_SIDE) ? _sceneWidth - this.width : 0;
			//this.y = (_movingContainer.x + _mainSprite.x)/(-(_movingContainer.x + _hidedSprite.x))
		} else {

		}
	}

	private function create():void {
		this.graphics.beginFill(0xafcd32);
		this.graphics.drawRect(0, 0, 20, 20);
		this.graphics.endFill();
	}
}
}
