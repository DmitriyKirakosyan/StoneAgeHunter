package {
	import org.flixel.FlxPoint;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxPath;
	import game.hunters.Hunter;
	import flash.net.URLRequest;
	import events.TextureHolderEvent;
	import tilegraphic.SharedBitmapHolder;
	import flash.events.Event;
	import flash.net.URLLoader;
	import org.flixel.FlxTilemap;
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
		private var _tilemap:FlxTilemap;
		private var _drawingSprite:FlxSprite;
		private var _hunter:Hunter;
		private var _pressed:Boolean;
		
		private var _playerPath:FlxPath;
		
		private var _lastPoint:FlxPoint;
		[Embed(source="PrototypeTexture.png")] static public var ImgTextures:Class;
		[Embed(source="bricks.png")] static public var ImgBricks:Class;
		
		
		override public function create():void {
			_tilemap = new FlxTilemap();
			var levelData:Array = new Array(
														0,0,1,0,0,
														0,1,1,1,0,
														0,0,1,0,0);
			_tilemap.loadMap(FlxTilemap.arrayToCSV(levelData, 5), ImgTextures, 103, 100, 0, 0, 0);
			add(_tilemap);
			_drawingSprite = new FlxSprite(0, 0);
			_drawingSprite.pixels = new BitmapData(515, 300, true, 0);
			add(_drawingSprite);
			createPlayer();
		}
		
		private function createPlayer():void {
			_hunter = new Hunter(20, 20, ImgBricks);
			_hunter.view.alpha = .6;
			add(_hunter.view);
		}
		
		override public function update():void
		{
			super.update();
			

			if(FlxG.mouse.justPressed()) {
				if (_hunter.view.overlapsPoint(FlxG.mouse.getWorldPosition())) {
					_hunter.view.alpha = 1;
					_pressed = true;
				} else {
					if (_pressed && (!_playerPath || _playerPath.nodes.length < 3)) {
						var currentPoint:FlxPoint = getCurrentPoint();
						_drawingSprite.drawLine(currentPoint.x, currentPoint.y,
																		FlxG.mouse.x, FlxG.mouse.y, 0x0ffaab, 3);
						if (!_playerPath) { _playerPath = new FlxPath(); }
						updateLastPoint();
						_playerPath.add(_lastPoint.x, _lastPoint.y);
						if (_playerPath.nodes.length == 3) {
							_hunter.view.followPath(_playerPath);
							trace("playerPath length : " + _playerPath.nodes.length);
						}
					}
				}
//				FlxG.switchState(new MenuState());
			} else {
				//_hunter.view.
				if ((_playerPath && _playerPath.nodes.length == 3)) {
					if (_hunter.view.overlapsPoint(_playerPath.nodes[2])) {
						//trace("velosity ", _hunter.view.velocity);
						_hunter.view.velocity.x = 0;
						_hunter.view.velocity.y = 0;
						
						//_hunter.view.stopFollowingPath(true);
						//trace("acceleration : ", _hunter.view.acceleration);
					}
				/*
					if (_hunter.view.x + _hunter.view.width/2 > _hunter.view.path.nodes[2].x -1 &&
							_hunter.view.x + _hunter.view.width/2 < _hunter.view.path.nodes[2].x +1 &&
							_hunter.view.y + _hunter.view.height/2 > _hunter.view.path.nodes[2].y - 1 &&
							_hunter.view.y + _hunter.view.height/2 < _hunter.view.path.nodes[2].y + 1) {
								trace("complete moveing");
								_hunter.view.stopFollowingPath();
					} else {
						trace("compare x : " + Math.abs(_hunter.view.x - _hunter.view.path.nodes[2].x) +
									", compare y : " + Math.abs(_hunter.view.y - _hunter.view.path.nodes[2].y));
					}
				 * 
				 */
				}
				if (_hunter.view.path == null) { trace("path == 0");}
			}
		}
		
		private function updateLastPoint():void {
			if (!_lastPoint) { _lastPoint = new FlxPoint(FlxG.mouse.x, FlxG.mouse.y);
			} else {
				_lastPoint.x = FlxG.mouse.x;
				_lastPoint.y = FlxG.mouse.y;
			}
		}
		
		private function getCurrentPoint():FlxPoint {
			return _lastPoint ||
								new FlxPoint(_hunter.view.x + _hunter.view.width/2,
															_hunter.view.y + _hunter.view.height/2);
		}
		
	}
}
