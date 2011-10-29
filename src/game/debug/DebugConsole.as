/**
 * Created by : Dmitry
 * Date: 10/29/11
 * Time: 11:58 PM
 */
package game.debug {
import com.greensock.TimelineMax;
import com.greensock.TweenLite;
import com.greensock.TweenMax;

import flash.display.Sprite;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.ui.Keyboard;

import game.GameScene;
import game.player.Hunter;

import mx.controls.Text;
import mx.effects.Tween;

public class DebugConsole {
	private var _gameScene:GameScene;
	private var _container:Sprite;
	private var _mode:uint;
	private var _arrow:Sprite;
	private var _consoleTF:TextField;


	private static const WIDTH:int = 200;
	private static const HEIGHT:int = 20;

	private const MODE_OPEN:uint = 0;
	private const MODE_HIDE:uint = 1;

	private const HUNTER_HP_POS_X:String = "hunter.hp.x=";
	private const HUNTER_HP_POS_Y:String = "hunter.hp.y=";
	private const HUNTER_HP_VISIBLE:String = "hunter.hp.visible=";

	public function DebugConsole(gameScene:GameScene) {
		super();
		_gameScene = gameScene;
		_container = new Sprite();
		_container.x = 100;
		_container.y = -10;
		_gameScene.gameContainer.addChild(_container);
		createArrow();
		createConsole();
		addListeners();
	}

	public function init():void {
		_container.addChild(_arrow);
		_container.addChild(_consoleTF);
		_mode = MODE_HIDE;
	}

	public function remove():void {
		_container.removeChild(_arrow);
		_container.removeChild(_consoleTF);
	}


	/* Internal functions */

	private function open():void {
		_mode = MODE_OPEN;
		TweenLite.killTweensOf(_container);
		TweenLite.to(_container, .5, {y : 0});
	}

	private function hide():void {
		_mode = MODE_HIDE;
		TweenLite.killTweensOf(_container);
		TweenLite.to(_container, .5, {y : -10} );
	}

	private function addListeners():void {
		_arrow.addEventListener(MouseEvent.CLICK, onArrowClick);
		_consoleTF.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPressed);
	}

	private function onArrowClick(event:MouseEvent):void {
		if (_mode == MODE_HIDE) { open();
		} else { hide(); }
	}

	private function onKeyPressed(event:KeyboardEvent):void {
		if (event.charCode == Keyboard.ENTER) {
			parceAndApplyText();
		}
	}

	private function parceAndApplyText():void {
		if (_consoleTF.text.indexOf(HUNTER_HP_POS_X) != -1) {
			var strX:String = _consoleTF.text.substr(_consoleTF.text.indexOf(HUNTER_HP_POS_X) + HUNTER_HP_POS_X.length);
			changeHunterHpX(Number(strX));
			return;
		}
		if (_consoleTF.text.indexOf(HUNTER_HP_POS_Y) != -1) {
			var strY:String = _consoleTF.text.substr(_consoleTF.text.indexOf(HUNTER_HP_POS_Y) + HUNTER_HP_POS_Y.length);
			changeHunterHpY(Number(strY));
			return;
		}
		if (_consoleTF.text.indexOf(HUNTER_HP_VISIBLE) != -1) {
			var strVisible:String = _consoleTF.text.substr(_consoleTF.text.indexOf(HUNTER_HP_VISIBLE) + HUNTER_HP_VISIBLE.length);
			changeHunterHpVisible(strVisible == true);
			return;
		}
	}

	private function changeHunterHpX(x:Number):void {
		 for each (var hunter:Hunter in _gameScene.hunters) {
			hunter.hpBar.x = x;
		 }
	}
	private function changeHunterHpY(y:Number):void {
		 for each (var hunter:Hunter in _gameScene.hunters) {
			hunter.hpBar.y = y;
		 }
	}
	private function changeHunterHpVisible(visible:Boolean):void {
		 for each (var hunter:Hunter in _gameScene.hunters) {
			hunter.hpBar.visible = visible;
		 }
	}

	private function createConsole():void {
		_consoleTF = new TextField();
		_consoleTF.autoSize = TextFieldAutoSize.LEFT;
		_consoleTF.type = TextFieldType.INPUT;
		_consoleTF.text = "hunter.hp.x=-30";
	}

	private function createArrow():void {
		_arrow = new Sprite;
		_arrow.graphics.beginFill(0x0fafcf);
		_arrow.graphics.drawRect(-20, -5, 40, 10);
		_arrow.graphics.endFill();
		_arrow.x = WIDTH/2;
		_arrow.y = 20;
	}
}
}
