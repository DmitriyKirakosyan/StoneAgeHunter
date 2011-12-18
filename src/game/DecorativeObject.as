package game
{
	import animation.IcSprite;
	
	import flash.display.Sprite;
	
	public class DecorativeObject extends IcSprite
	{
		public function DecorativeObject(view:Sprite)
		{
			super();
			addChild(view);
		}
	}
}