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
		
		private var _backDecorations:BackDecorations;
		
		private var _decoraativeObjects:Vector.<DecorativeObject>
		
		private var _debugPanel:DebugPanel;
		private var _debugConsole:DebugConsole;
		
		private var _selectedHunter:Hunter;
		public var active:Boolean;
		
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
		
		public function get decoraativeObjects():Vector.<DecorativeObject>
		{
			return _decoraativeObjects;
		}

		public function set decoraativeObjects(value:Vector.<DecorativeObject>):void
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
			_debugPanel.open();
			_debugConsole.init();
		}
		public function close():void {
			_debugConsole.remove();
			_debugPanel.close();
			removeHunter();
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
										 {ease:Linear.easeNone, x : event.stageX, y : event.stageY,
										 onComplete : function():void {_hunter.stop();}});
			}
		}
		
		private function createHunter():void {
			trace("createHunter")
			_hunter = new Hunter(false);
			_hunter.x = 350;
			_hunter.y = 300;
			_gameContainer.addChild(_hunter);
		}
		
		private function removeHunter():void {
			_gameContainer.removeChild(_hunter);
		}

		private function onAnimalClick(event:MouseEvent):void {
			if (_selectedHunter && _selectedHunter.path) {
				_selectedHunter.path.setAttackPoint();
			}
		}
		
		private function showHunterExistingPath(hunter:Hunter):void {
			if (!hunter) { return; }
			if (hunter.path) {
				for each (var point:KeyPoint in hunter.path.points) {
					point.alpha = 1;
				}
			}
			if (hunter.path.links) { hunter.path.links.forEach(function(item:LinkToPoint, ..._):void { item.alpha = 1; }); }
		}
		
		private function hideCurrentPath():void {
			if (!_selectedHunter.path) { return; }
			for each (var keyPoint:KeyPoint in _selectedHunter.path.points) {
				keyPoint.alpha = .4;
			}
			if (_selectedHunter.path.links) { _selectedHunter.path.links.forEach(function(item:LinkToPoint, ..._):void { item.alpha = .4; }); }
		}
		
	}
}
