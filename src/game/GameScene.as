package game {
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import game.debug.DebugConsole;
	import game.debug.DebugPanel;
	import game.player.Hunter;
	
	import scene.IScene;
	import scene.SceneEvent;
	
	import game.map.tilemap.TileMap;

	public class GameScene extends EventDispatcher implements IScene {
		private const WIDTH:Number = 1000;
		private const HEIGHT:Number = 1000;

		private const WINDOW_WIDTH:Number = 550;
		private const WINDOW_HEIGHT:Number = 400;

		private var _currentMousePoint:Point;

		private var _gameContainer:Sprite;
		private var _hunter:Hunter;
		
		private var _zSortingManager:ZSortingManager;
		private var _parallaxManager:ParallaxManager;
		private var _perspectiveManager:PerspectiveManager;

		private  const CONTAINER_MOVE_SPEED:int = 3;
		private const HUNTER_THROW_PERIOD:int = 5;
		private var _hunterThrowCounter:Number = 0;
		
		private var _backDecorations:BackDecorations;
		
		private var _decoraativeObjects:Vector.<DecorativeObject> = new Vector.<DecorativeObject>;
		
		private var _debugPanel:DebugPanel;
		//private var _debugConsole:DebugConsole;
		
		public var active:Boolean = true;
		
		private var _mouseDown:Boolean;
		
		public function GameScene(container:Sprite, tileMap:TileMap):void {
			super();
			_gameContainer = new Sprite();
			_gameContainer.graphics.beginFill(0,.2);
			_gameContainer.graphics.drawRect(0,0,WIDTH,HEIGHT);
			_gameContainer.graphics.endFill();
			_gameContainer.x = -400;
			_gameContainer.y = -200;
			_debugPanel = new DebugPanel(container, this);
			//_debugConsole = new DebugConsole(this);
			_zSortingManager = new ZSortingManager(this);
			_parallaxManager = new ParallaxManager(this);
			_perspectiveManager = new PerspectiveManager(this);
			//backDecorations = new BackDecorations;
			//gameContainer.addChild(backDecorations);
			container.addChild(_gameContainer);
			_gameContainer.addEventListener(Event.ENTER_FRAME, onGameContainerEnterFrame);
			container.addEventListener(MouseEvent.MOUSE_DOWN, onContainerMouseDown);
			container.addEventListener(MouseEvent.MOUSE_UP, onContainerMouseUp);
			container.addEventListener(MouseEvent.MOUSE_MOVE, onContainerMouseMove);
			
		}
		
		protected function onContainerMouseMove(event:MouseEvent):void
		{
			if (!_currentMousePoint) { _currentMousePoint = new Point(); }
			_currentMousePoint.x = event.stageX;
			_currentMousePoint.y = event.stageY;
			if(_hunter && _mouseDown){
				moveHunterToCurrentMousePoint();
			}
		}

		private function moveHunterToCurrentMousePoint():void {
			_hunter.move();
			var toPoint:Point = new Point(_currentMousePoint.x - _gameContainer.x,
							         							_currentMousePoint.y - _gameContainer.y);
			TweenLite.killTweensOf(_hunter);
			_hunter.changeAnimationAndRotation(toPoint)
			TweenLite.to(_hunter,
				_hunter.computeDuration(new Point(_hunter.x, _hunter.y), toPoint),
				{ease:Linear.easeNone, realXpos : toPoint.x, y : toPoint.y,
					onComplete : function():void {_hunter.stop();}});
		}
		
		/* functions for debug */
		
		public function get allObjects():Array {
			var newArray:Array = new Array();
			
			return newArray;
		}

		public function get decorativeObjects():Vector.<DecorativeObject> {
			return _decoraativeObjects;
		}

		public function get backDecorations():BackDecorations
		{
			return _backDecorations;
		}

		public function set backDecorations(value:BackDecorations):void
		{
			_backDecorations = value;
		}

		public function get gameContainer():Sprite { return _gameContainer; }

		public function get hunter():Hunter { return _hunter; }
		
		public function dispatchAboutClose():void {
			dispatchEvent(new SceneEvent(SceneEvent.SWITCH_ME, this));
		}
		
		public function open():void {
			createHunter();
			createDecorativeObjects();
			_parallaxManager.open();
			_debugPanel.open();
		}
		public function close():void {
			_parallaxManager.close();
			_debugPanel.close();
			removeHunter();
		}


		//делаем всякие камушки - хуямушки
		private function createDecorativeObjects():void {
			var decorate:DecorativeObject;
			for (var i:int = 0; i < 30; i++){
				decorate = DecorativeObject.createLittleHill();
				decorate.realXpos = Math.random() * (WIDTH-100) + 50;
				decorate.y = Math.random() * (HEIGHT-100) +50;
				_gameContainer.addChild(decorate);
				decorativeObjects.push(decorate);
			}
			decorate = DecorativeObject.createPaddle();
			decorativeObjects.push(decorate)
			_gameContainer.addChild(decorate);
			decorate.realXpos = 200;
			decorate.y= 200;
			decorate.underAll = true;
		}
		
		/* Internal functions */
		
		private function onGameContainerEnterFrame(event:Event):void {
			_zSortingManager.checkZSorting();
			if (!_hunter) { return; }
			if (mouseAroundSide()) {
				scrollContainer();
			}
			_hunterThrowCounter += 1/Main.FRAME_RATE;
			if (_hunterThrowCounter >= HUNTER_THROW_PERIOD) {
				_hunterThrowCounter = 0;
				_hunter.throwStone();
			}
		}

		private function scrollContainer():void {
			if (_gameContainer.x + _hunter.x < 200) { _gameContainer.x += CONTAINER_MOVE_SPEED; }
			if (_gameContainer.x + _hunter.x > WINDOW_WIDTH-200) { _gameContainer.x-= CONTAINER_MOVE_SPEED; }
			if (_gameContainer.y + _hunter.y < 200) { _gameContainer.y+= CONTAINER_MOVE_SPEED; }
			if (_gameContainer.y + _hunter.y > WINDOW_HEIGHT-200) { _gameContainer.y-= CONTAINER_MOVE_SPEED; }
		}

		private function mouseAroundSide():Boolean {
			return (_gameContainer.x + _hunter.x < 200) ||
							(_gameContainer.x + _hunter.x > WINDOW_WIDTH-200) ||
							(_gameContainer.y + _hunter.y < 200) ||
							(_gameContainer.y + _hunter.y > WINDOW_HEIGHT-200);
		}

		private function onContainerMouseDown(event:MouseEvent):void {
			_mouseDown = true;
			if(_hunter){
				moveHunterToCurrentMousePoint();
			}
		//	_parallaxManager.deactivateIfNot();
		}
		protected function onContainerMouseUp(event:MouseEvent):void {
			_mouseDown = false;
		//	_parallaxManager.activateIfNot();
		}


		private function createHunter():void {
			trace("createHunter");
			_hunter = new Hunter(false);
			//_hunter.realXpos = 350;
			//_hunter.y = 300;
			_gameContainer.addChild(_hunter);
		}
		
		private function removeHunter():void {
			_gameContainer.removeChild(_hunter);
		}
		
		
	}
}
