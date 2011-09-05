package {
	import org.flixel.FlxCamera;
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
			var camera:FlxCamera = FlxG.cameras[0];
			new GameController(camera.getContainerSprite());
		}
	}
}
