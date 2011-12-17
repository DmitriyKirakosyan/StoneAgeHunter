package game
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class BackDecorations extends Sprite
	{
		//неаккуратно состыковал сталактиты, надеюсь в будущем эта константа вообще не понадобится
		private const ARTIST_ACCURACY:int = 2;
		
		//собственно в нем и содержатся все сталактиты/сталагмиты ну и что там по графике уровню соответствует
		private var backContainer:Sprite = new Sprite();
		
		//фоновые подложки
		private var backBack:Sprite;
		private var background:Sprite;
		
		private var decorationParts:Vector.<MovieClip> = new Vector.<MovieClip>;
		
		private var _offsetX:int = 0;
		
		public function BackDecorations()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onnAddedToStage);
		}
		
		public function get offsetX():int
		{
			return _offsetX;
		}

		public function set offsetX(value:int):void
		{
			_offsetX = value;
		}

		protected function onnAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onnAddedToStage);
			init();
			
			backBack = LevelDecorationManager.getDecorationElement("backback");
			background = LevelDecorationManager.getDecorationElement("background");
			
			addChild(backBack);
			addChild(background);
			
			background.y = stage.stageHeight - background.height;
			backBack.y = background.y - backBack.height;
			backContainer.y = background.y - backContainer.height + 14;
			backContainer.x = -(backContainer.width - stage.stageWidth)/2;
			
			addChild(backContainer);
		}
		
		private function init():void{
			while(backContainer.width < stage.stageWidth){
				var randomElement:String = randomBackElement("stalactyte");
				decorationParts.push(LevelDecorationManager.getDecorationElement(randomElement));
				backContainer.addChild(decorationParts[decorationParts.length -1]);
				decorationParts[decorationParts.length -1].x = (decorationParts.length -1) * (decorationParts[decorationParts.length -1].width - ARTIST_ACCURACY);
			}
		}
		
		private function randomBackElement(element:String):String{
			return(element + Math.round(Math.random()* 9).toString());
		}
		
		
	}
}