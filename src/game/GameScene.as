package game {
	import animation.IcSprite;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.greensock.easing.Linear;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import game.animals.AnimalEvent;
	import game.animals.Duck;
	import game.armor.Stone;
	import game.debug.DebugConsole;
	import game.debug.DebugPanel;
	import game.gameActor.ActerKeyPointEvent;
	import game.gameActor.IcActerEvent;
	import game.gameActor.KeyPoint;
	import game.gameActor.LinkToPoint;
	import game.player.Hunter;
	
	import scene.IScene;
	import scene.SceneEvent;
	
	import tilemap.TileMap;

	public class GameScene extends EventDispatcher implements IScene {
		private var _mapContainer:Sprite;
		private var _gameContainer:Sprite;
		private var _hunter:Hunter;
		
		private var _zSortingManager:ZSortingManager;
		private var _parallaxManager:ParallaxManager;
		private var _perspectiveManager:PerspectiveManager;
		
		private var _mobManager:MobManager;
		
		private var _backDecorations:BackDecorations;
		
		private var _decoraativeObjects:Vector.<DecorativeObject> = new Vector.<DecorativeObject>;
		
		private var _debugPanel:DebugPanel;
		private var _debugConsole:DebugConsole;
		
		public var active:Boolean = true;
		
		public function GameScene(container:Sprite, tileMap:TileMap):void {
			super();
			_mapContainer = new Sprite();
			_gameContainer = new Sprite();
			_debugPanel = new DebugPanel(container, this);
			_debugConsole = new DebugConsole(this);
			_zSortingManager = new ZSortingManager(this);
			_parallaxManager = new ParallaxManager(this);
			_perspectiveManager = new PerspectiveManager(this);
			backDecorations = new BackDecorations;
			gameContainer.addChild(backDecorations);
			container.addChild(_mapContainer);
			container.addChild(_gameContainer);
			_gameContainer.addEventListener(Event.ENTER_FRAME, onGameContainerEnterFrame);
			container.addEventListener(MouseEvent.MOUSE_DOWN, onContainerMouseDown);
		}
		
		/* functions for debug */
		
		public function get allObjects():Array
		{
			var newArray:Array = new Array();
			
			return newArray;
		}

		public function get decorativeObjects():Vector.<DecorativeObject>
		{
			return _decoraativeObjects;
		}

		public function set decorativeObjects(value:Vector.<DecorativeObject>):void
		{
			_decoraativeObjects = value;
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
		
		public function get mapContainer():Sprite {
			return _mapContainer;
		}
		
		public function dispatchAboutClose():void {
			dispatchEvent(new SceneEvent(SceneEvent.SWITCH_ME, this));
		}
		
		public function open():void {
			createHunter();
			createDecorativeObjects();
			_debugPanel.open();
			_debugConsole.init();
		}
		
		private function createDecorativeObjects():void {
			for (var i:int = 0; i < 10; i++){
				decorativeObjects.push(new DecorativeObject(LevelDecorationManager.getDecorationElement("littleHill")));
				_gameContainer.addChild(decorativeObjects[i]);
				decorativeObjects[i].realXpos = Math.round(Math.random() * _gameContainer.stage.stageWidth);
				decorativeObjects[i].y = Math.round(Math.random() * (_gameContainer.stage.stageHeight - 80)) +70;
			}
			decorativeObjects.push(new DecorativeObject(LevelDecorationManager.getDecorationElement("paddle")))
			_gameContainer.addChild(decorativeObjects[decorativeObjects.length-1]);	
			decorativeObjects[decorativeObjects.length-1].realXpos = 200;
			decorativeObjects[decorativeObjects.length-1].y= 200;
		}
		
		public function close():void {
			_debugConsole.remove();
			_debugPanel.close();
			removeHunter();
			removeDecorativeObjects();
		}
		
		private function removeDecorativeObjects():void
		{
			// TODO Auto Generated method stub
			
		}
		
		/* Internal functions */
		
		private function onGameContainerEnterFrame(event:Event):void {
			_zSortingManager.checkZSorting();
		}

		private function onContainerMouseDown(event:MouseEvent):void {
			if(_hunter){
				_hunter.move();
				TweenLite.to(_hunter,
										 _hunter.computeDuration(new Point(_hunter.x, _hunter.y), new Point(event.stageX, event.stageY)),
										 {ease:Linear.easeNone, realXpos : event.stageX, y : event.stageY,
										 onComplete : function():void {_hunter.stop();}});
			}
		}
		
		private function createHunter():void {
			trace("createHunter")
			_hunter = new Hunter(false);
			_hunter.realXpos = 350;
			_hunter.y = 300;
			_gameContainer.addChild(_hunter);
		}
		
		private function removeHunter():void {
			_gameContainer.removeChild(_hunter);
		}
		
		
	}
}
