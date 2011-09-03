package {
	import flash.utils.Dictionary;
	import flash.display.Sprite;
	public class LayerManager {
		private static var _instance:LayerManager;
		
		private static var _layers:Dictionary;
		
		public static const GAME:String = "gameLayer";
		public static const EFFECTS:String = "effectsLayer";
		
		public static function get instance():LayerManager {
			if (!_instance) { _instance = new LayerManager; }
			return _instance;
		}
		
		public static function init(container:Sprite):void {
			_layers = new Dictionary();
			_layers[GAME] = new Sprite();
			container.addChild(_layers[GAME]);
		}
		
		public static function getLayer(layerName:String):Sprite {
			return _layers[layerName];
		}
	}
}
