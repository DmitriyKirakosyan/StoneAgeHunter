package game
{
	import flash.display.MovieClip;

	public class LevelDecorationManager
	{	
		public function LevelDecorationManager()
		{
			
		}
		
		public static function getDecorationElement(element:String):MovieClip{
			switch(element){
			//LEVEL1
				case "stalactyte0":
					return new Stalactyte0View();
					break;
				case "stalactyte1":
					return new Stalactyte1View();
					break;
				case "stalactyte2":
					return new Stalactyte2View();
					break;
				case "stalactyte3":
					return new Stalactyte3View();
					break;
				case "stalactyte4":
					return new Stalactyte4View();
					break;
				case "stalactyte5":
					return new Stalactyte5View();
					break;
				case "stalactyte6":
					return new Stalactyte6View();
					break;
				case "stalactyte7":
					return new Stalactyte7View();
					break;
				case "stalactyte8":
					return new Stalactyte8View();
					break;
				case "stalactyte9":
					return new Stalactyte9View();
					break;
				case "backback":
					return new BackStageDecorationsBackground();
					break;
				case "background":
					return new BackgroundView();
					break;
				case "stone":
					return new StoneView();
					break;
				case "littleHill":
					return new LittleHillView();
					break;
				case "paddle":
					return new UsualPaddleView();
					break;
				default:
					return new MovieClip();
					break;
			}
		}
	}
}