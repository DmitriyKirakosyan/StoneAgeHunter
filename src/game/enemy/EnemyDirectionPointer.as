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

	public function updatePosition(side:uint):void {
		var divOn:Number;
		if (side == RIGHT_SIDE || side == LEFT_SIDE) {
			this.x = (side == RIGHT_SIDE) ? _sceneWidth - this.width : 0;
			divOn = (side == RIGHT_SIDE) ?
							           (1 + ((-(_movingContainer.x + _hidedSprite.x))/(_movingContainer.x + _mainSprite.x)) ) :
												 (1 + (((_movingContainer.x + _hidedSprite.x) - _sceneWidth)/(_sceneWidth - (_movingContainer.x + _mainSprite.x))) );
			this.y = _movingContainer.y + _mainSprite.y + (_hidedSprite.y - _mainSprite.y)/ divOn;
		} else {
			this.y = (side == TOP_SIDE) ? 0 : _sceneHeight - this.height;
			divOn = (side == TOP_SIDE) ?
							(1 + ((-(_movingContainer.y + _hidedSprite.y))/(_movingContainer.y + _mainSprite.y)) ) :
							(1 + (((_movingContainer.y + _hidedSprite.y) - _sceneHeight)/(_sceneHeight - (_movingContainer.y + _mainSprite.y))) );
			this.x = _movingContainer.x + _mainSprite.x + (_hidedSprite.x - _mainSprite.x)/ divOn;
		}
	}

	private function create():void {
		this.graphics.beginFill(0xafcd32);
		this.graphics.drawRect(0, 0, 20, 20);
		this.graphics.endFill();
	}
}
}
