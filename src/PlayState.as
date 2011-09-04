package {
	import flash.display.MovieClip;
	import mx.core.BitmapAsset;
	import flash.text.engine.GraphicElement;
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import game.GameController;
	import org.flixel.FlxState;

	public class PlayState extends FlxState {
		override public function create():void {
			
			var shape:BitmapData;
			var bamView:BamView = new BamView();
			shape = new BitmapData(bamView.width, bamView.height);
			shape.draw(bamView, bamView.transform.matrix, bamView.transform.colorTransform);
			var flxSprite:FlxSprite = new FlxSprite(10,10);
			flxSprite.alpha = .3;
			flxSprite.pixels = shape;
			add(flxSprite);
			
			//new GameController();
		}
	}
}
