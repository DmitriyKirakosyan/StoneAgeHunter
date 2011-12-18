package game
{
	import animation.IcSprite;
	
	import event.IcSpriteEvent;
	
	import flash.events.Event;

	public class PerspectiveManager
	{
		private var _gameScene:GameScene;
		private var perspactiveForce:Number = 0.002;
		
		public function PerspectiveManager(gameScene:GameScene)
		{
			_gameScene = gameScene;
			_gameScene.gameContainer.addEventListener(IcSpriteEvent.MOVE, onSpriteMove);
		}
		
		protected function onSpriteMove(event:IcSpriteEvent):void
		{
			var tempSprite:IcSprite = (event as IcSpriteEvent).icTarget;
			(event as IcSpriteEvent).icTarget.scaleX = tempSprite.scaleY = 0.7 + tempSprite.y * perspactiveForce;
		}
	}
}