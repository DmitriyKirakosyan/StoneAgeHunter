package game.hunters {
	import flash.events.EventDispatcher;
	import flash.filters.GlowFilter;
	import events.HunterEvent;
	import flash.display.Sprite;
	import game.GameController;
	public class HuntersController extends EventDispatcher{
		private var _container:Sprite;
		
		private var _hunters:Vector.<Hunter>;
		
		public function HuntersController(container:Sprite):void {
			super();
			_container = container;
		}
		
		/* API */
		
		public function createHunters():void {
			_hunters = new Vector.<Hunter>();
			var hunter:Hunter;
			for (var i:int = 0; i < 5; ++i) {
				hunter = new Hunter();
				addHunterXY(hunter);
				addHunterListeners(hunter);
				_container.addChild(hunter);
				_hunters.push(hunter);
			}
		}
		
		/* Internal functions */
		
		private function addHunterXY(hunter:Hunter):void {
				hunter.x = hunter.width/2 + 
									Math.random() * (GameController.GAME_WIDTH/2 - hunter.width);
				if (hunter.x > GameController.GAME_WIDTH/4) {
					hunter.x += GameController.GAME_WIDTH/2;
				}
				hunter.y = hunter.height/2 + 
										Math.random() * (GameController.GAME_HEIGHT/2 - hunter.height);
				if (hunter.y > GameController.GAME_HEIGHT/4) {
					hunter.y += GameController.GAME_HEIGHT/2;
				}
		}
		
		private function addHunterListeners(hunter:Hunter):void {
			hunter.addEventListener(HunterEvent.CLICK, onHunterClick);
		}
		
		private function onHunterClick(event:HunterEvent):void {
			for each (var hunter:Hunter in _hunters) {
				hunter.filters = [];
			}
			event.hunter.filters = [new GlowFilter(0x00ffff)];
			dispatchEvent(new HunterEvent(HunterEvent.CLICK, event.hunter));
		}
	}
}
