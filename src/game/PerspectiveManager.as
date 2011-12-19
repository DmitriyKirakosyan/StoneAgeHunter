package game
{
	import animation.IcSprite;
	
	import events.IcSpriteEvent;
	
	import flash.events.Event;

	public class PerspectiveManager
	{
		private var _gameScene:GameScene;
		private var perspactiveForce:Number = 0.002;
		
		public function PerspectiveManager(gameScene:GameScene)
		{
			_gameScene = gameScene;
			_gameScene.gameContainer.addEventListener(IcSpriteEvent.MOVE_BY_Y, onSpriteMove);
		}
		
		protected function onSpriteMove(event:IcSpriteEvent):void
		{
			var icSprite:IcSprite = event.icTarget;
			var scale:Number = 0.7 + icSprite.y * perspactiveForce;
			icSprite.scaleX = (icSprite.scaleX < 0) ? -scale : scale;
			icSprite.scaleY = scale;
		}
	}
}