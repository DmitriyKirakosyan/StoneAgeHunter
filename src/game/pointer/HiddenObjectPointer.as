/**
 * Created by : Dmitry
 * Date: 4/1/12
 * Time: 12:16 PM
 */
package game.pointer {
import flash.display.Sprite;

public class HiddenObjectPointer extends Sprite {
	private var _arrowSprite:Sprite;

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

	private static const ARROW_SIDE_MARGIN:Number = 2;

	public static function createEnemyPointer(sceneWidth:int, sceneHeight:int, hidedSprite:Sprite, mainSprite:Sprite, movingContainer:Sprite):HiddenObjectPointer {
		return new HiddenObjectPointer(sceneWidth, sceneHeight, hidedSprite, mainSprite, movingContainer, new RedArrowView());
	}

	public static function createBonusPointer(sceneWidth:int, sceneHeight:int, hidedSprite:Sprite, mainSprite:Sprite, movingContainer:Sprite):HiddenObjectPointer {
		return new HiddenObjectPointer(sceneWidth, sceneHeight, hidedSprite, mainSprite, movingContainer, new BonusArrowView());
	}

	public function HiddenObjectPointer(sceneWidth:int, sceneHeight:int, hidedSprite:Sprite, mainSprite:Sprite, movingContainer:Sprite, arrowSprite:Sprite):void {
		_sceneHeight = sceneHeight;
		_sceneWidth = sceneWidth;
		_hidedSprite = hidedSprite;
		_mainSprite = mainSprite;
		_movingContainer = movingContainer;
		_arrowSprite = arrowSprite;
		this.addChild(_arrowSprite);
	}

	public function updatePosition():void {
		_side = getSideForHiddenSprite();
		updateRotation(_side);
		var divOn:Number;
		if (_side == RIGHT_SIDE || _side == LEFT_SIDE) {
			this.x = (_side == RIGHT_SIDE) ? _sceneWidth - this.width : 0;
			divOn = (_side == RIGHT_SIDE) ?
							           (1 + ((-(_movingContainer.x + _hidedSprite.x))/(_movingContainer.x + _mainSprite.x)) ) :
												 (1 + (((_movingContainer.x + _hidedSprite.x) - _sceneWidth)/(_sceneWidth - (_movingContainer.x + _mainSprite.x))) );
			this.y = _movingContainer.y + _mainSprite.y - (_hidedSprite.y - _mainSprite.y)/ divOn;
		} else {
			this.y = (_side == TOP_SIDE) ? 0 : _sceneHeight - this.height;
			divOn = (_side == TOP_SIDE) ?
							(1 + ((-(_movingContainer.y + _hidedSprite.y))/(_movingContainer.y + _mainSprite.y)) ) :
							(1 + (((_movingContainer.y + _hidedSprite.y) - _sceneHeight)/(_sceneHeight - (_movingContainer.y + _mainSprite.y))) );
			this.x = _movingContainer.x + _mainSprite.x + (_hidedSprite.x - _mainSprite.x)/ divOn;
		}
	}

	private function updateRotation(side:uint):void {
		if (side == RIGHT_SIDE) {
			_arrowSprite.y = -_arrowSprite.height/2;
			_arrowSprite.x = _arrowSprite.width - ARROW_SIDE_MARGIN;
		} else if (side == BOTTOM_SIDE) {
			_arrowSprite.y = _arrowSprite.height - ARROW_SIDE_MARGIN;
			_arrowSprite.x = _arrowSprite.width/2;
		} else if (side == LEFT_SIDE) {
			_arrowSprite.y = _arrowSprite.height/2;
			_arrowSprite.x = ARROW_SIDE_MARGIN;
		} else {
			_arrowSprite.y = ARROW_SIDE_MARGIN;
			_arrowSprite.x = _arrowSprite.width/2;
		}
		_arrowSprite.rotation = (side == RIGHT_SIDE) ? 90 : (side == BOTTOM_SIDE) ? 180 : (side == LEFT_SIDE) ? -90 : 0;
	}

	private function getSideForHiddenSprite():uint {
		var result:uint;
		if (_hidedSprite.x + _movingContainer.x < 0) {
			result = LEFT_SIDE;
		}
		if (_hidedSprite.y + _movingContainer.y < 0) {
			if (result == LEFT_SIDE) {
				if (_hidedSprite.y + _movingContainer.y < _hidedSprite.x + _movingContainer.x) {
					result = TOP_SIDE;
				}
			} else {
				result = TOP_SIDE;
			}
		}
		if (_hidedSprite.x + _movingContainer.x > Main.WIDTH) {
			if (result == TOP_SIDE) {
				if ((_hidedSprite.x + _movingContainer.x) - Main.WIDTH > -_hidedSprite.y - _movingContainer.y ) {
					result = RIGHT_SIDE;
				}
			} else { result = RIGHT_SIDE; }
		}
		if (_hidedSprite.y + _movingContainer.y > Main.HEIGHT) {
			if (result == LEFT_SIDE) {
				if ((_hidedSprite.y + _movingContainer.y)-Main.HEIGHT > -_hidedSprite.x - _movingContainer.x) {
					result = BOTTOM_SIDE;
				}
			} else if (result == RIGHT_SIDE) {
				if ((_hidedSprite.y + _movingContainer.y)-Main.HEIGHT > (_hidedSprite.x + _movingContainer.x)-Main.WIDTH) {
					result = BOTTOM_SIDE;
				}
			} else { result = BOTTOM_SIDE; }
		}
		return result
	}

}
}
