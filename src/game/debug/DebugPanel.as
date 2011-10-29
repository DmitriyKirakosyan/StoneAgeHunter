package game.debug {
import game.*;
	import com.bit101.components.PushButton;
	import com.bit101.components.RadioButton;
	import com.bit101.components.Slider;
	
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
import flash.geom.Point;
import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import game.player.Hunter;

import leveleditor.LevelEditor;

public class DebugPanel {
		private var _gameSceneContainer:Sprite;
		private var _container:Sprite;
		private var _gameScene:GameScene;
	
		private var _goMenuBtn:PushButton;
		private var _openLevelEditorBtn:PushButton;
		private var _fullScreenBtn:PushButton;
		
		private var _huntersSpeedSlider:Slider;
		private var _animalSpeedSlider:Slider;
		private var _huntersHpSlider:Slider;
		private var _animalHpSlider:Slider;
		private var _pathPartsDistanceSlider:Slider;
		private var _huntersScaleSlider:Slider;
		private var _animalScaleSlider:Slider;
		private var _pathPartCircle:RadioButton;
		private var _pathPartRectangle:RadioButton;

		private var _levelEditor:LevelEditor;
		
		public function DebugPanel(container:Sprite, gameScene:GameScene):void {
			super();
			_gameSceneContainer = container;
			_container = new Sprite();
			_container.visible = false;
			_gameScene = gameScene;
			_levelEditor = new LevelEditor(container, new Point(0, 0));
			createButtons();
			
			_gameSceneContainer.addEventListener(MouseEvent.CLICK, onKeyDown);
		}
		
		public function open():void {
			addButtons();
		}
		
		public function close():void {
			removeButtons();
		}
		
		/* Internal functions */
		
		private function onKeyDown(event:MouseEvent):void {
			if (event.ctrlKey) {
				_container.visible = !_container.visible;
			}
		}
		
		//TODO bad memory managment here, а мне плевать
		
		private function createButtons():void {
			_goMenuBtn = new PushButton(_container, 400, 80, "go to menu", onButtonMenuClick);
			_openLevelEditorBtn = new PushButton(_container, 400, 100, "open level editor", onOpenLevelEditorClick);
			_pathPartCircle = new RadioButton(_container, 400, 50, "circle", true, onCircleClick);
			_pathPartRectangle = new RadioButton(_container, 450, 50, "rectangle", false, onRectangleClick);
			_fullScreenBtn = new PushButton(_container, 400, 20, "fullscreen", onFullScreenClick);
			
			createSliders();
		}
		
		private function createSliders():void {
			_huntersScaleSlider = createSlider(400, 170, onHunterScaleSlider, .1, 1, .3, "Hunters scale");
			_huntersScaleSlider.tick = .01;
			_animalScaleSlider = createSlider(400, 200, onAnimalScaleSlider, .1, 1, .3, "Duck scale");
			_animalScaleSlider.tick = .01;
			_huntersSpeedSlider = createSlider(400, 230, onHunterSpeedSlider, .1, 2, 1, "Hunters speed");
			_animalSpeedSlider = createSlider(400, 260, onAnimalSpeedSlider, .1, 2, .5, "Duck speed");
			_huntersHpSlider = createSlider(400, 290, onHunterHpSlider, 1, 5, 3, "Hunters hp");
			_animalHpSlider = createSlider(400, 320, onAnimalHpSlider, 1, 8, 5, "Duck hp");
			_pathPartsDistanceSlider = createSlider(400, 140, onPathPartsDistanceSlider, 0, 15, 2, "distance between path parts");
		}
		
		private function createSlider(x:Number, y:Number, handler:Function, minValue:Number, 
																	maxValue:Number, value:Number, name:String):Slider {
			createSliderLabel(name, x, y);
			const slider:Slider = new Slider("horizontal", _container, x, y + 15, handler);
			slider.maximum = maxValue;
			slider.minimum = minValue;
			slider.value = value;
			return slider;
		}
		
		private function createSliderLabel(text:String, x:Number, y:Number):void {
			const tf1:TextField = new TextField();
			tf1.text = text;
			tf1.selectable = false;
			tf1.autoSize = TextFieldAutoSize.LEFT;
			tf1.x = x;
			tf1.y = y;
			_container.addChild(tf1);
		}
		
		private function onCircleClick(event:Event):void {
			_gameScene.drawingController.setPartShape("circle");
		}
		
		private function onRectangleClick(event:Event):void {
			_gameScene.drawingController.setPartShape("rectangle");
		}
		
		private function onHunterScaleSlider(event:Event):void {
			for each (var hunter:Hunter in _gameScene.hunters) {
				hunter.setScale(_huntersScaleSlider.value);
			}
		}
		
		private function onAnimalScaleSlider(event:Event):void {
			_gameScene.duck.setScale(_animalScaleSlider.value);
		}
		private function onHunterSpeedSlider(event:Event):void {
			for each (var hunter:Hunter in _gameScene.hunters) {
				hunter.speed = _huntersSpeedSlider.value;
			}
		}
		private function onAnimalSpeedSlider(event:Event):void {
			_gameScene.duck.speed = _animalSpeedSlider.value;
		}
		
		private function onHunterHpSlider(event:Event):void {
			for each (var hunter:Hunter in _gameScene.hunters) {
				hunter.hp = _huntersHpSlider.value;
			}
		}
		private function onAnimalHpSlider(event:Event):void {
			_gameScene.duck.hp = _animalHpSlider.value;
		}
		
		private function onPathPartsDistanceSlider(event:Event):void {
			_gameScene.drawingController.setPathPartsDistance(_pathPartsDistanceSlider.value);
		}
		
		private function addButtons():void {
			_gameSceneContainer.addChild(_container);
		}
		
		private function removeButtons():void {
			if (_gameSceneContainer.contains(_container)) {
				_gameSceneContainer.removeChild(_container);
			}
		}
		
		private function onFullScreenClick(event:MouseEvent):void {
			if(_gameSceneContainer.stage){
				if (_gameSceneContainer.stage.displayState == StageDisplayState.NORMAL) {
					_gameSceneContainer.stage.displayState=StageDisplayState.FULL_SCREEN;
				} else {
					_gameSceneContainer.stage.displayState=StageDisplayState.NORMAL;
				}
			}
		}
		
		private function onButtonMenuClick(event:MouseEvent):void {
			event.stopPropagation();
			_gameScene.dispatchAboutClose();
		}

		private function onOpenLevelEditorClick(event:MouseEvent):void {
			event.stopPropagation();
			_levelEditor.open();
		}
		
	}
}
