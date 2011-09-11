package game.player {
	import flash.display.Sprite;

	public class Hunter extends Sprite {
		private var _view:Sprite;
		
		public function Hunter() {
			super();
			addImage();
		}
		
		/* API */
		
		public function remove():void {
			removeChild(_view);
			_view = null;
		}
		
		/* Internal functions */
		
		private function addImage():void {
			_view = new BricksView();
			addChild(_view);
		}
	}
}
