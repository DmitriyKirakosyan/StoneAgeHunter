package tilemap {
	import flash.display.Sprite;
	public class TileMap extends Sprite {
		private var _tiles:Vector.<Vector.<Tile>>;
		private var _textureName:String;
		private var _ready:Boolean;
		
		public function TileMap(textureName:String):void {
			super();
			_textureName = textureName;
			_ready = false;
			SharedBitmapHolder.instance.addEventListener(TextureHolderEvent.TEXTURE_LOADED, onTextureLoad);
			SharedBitmapHolder.load(textureName);
		}
		
		public function ready():Boolean { return _ready; }
		
		public function createByMatrixArray(matrix:Array, width:uint, height:uint):void {
			_tiles = new Vector.<Vector.<Tile>>();
			var tile:Tile;
			for (var i:int = 0; i < width; ++i) {
				_tiles[i] = new Vector.<Tile>();
				for (var j:int = 0; j < height; ++j) {
					tile = new Tile(TileTypes.tiles[matrix[i][j]], _textureName);
					_tiles[i].push(tile);
					tile.x = i * tile.width;
					tile.y = j * tile.height;
					if (i == 0 && j < height-1) {
						tile.x += tile.width;
						tile.rotation = 90;
					}
					if (i > 0 && j == 0) {
						tile.rotation = 180;
						tile.x += tile.width;
						tile.y += tile.height
					}
					if (i == width-1 && j > 0) { tile.rotation = 270; tile.y += tile.height}
					this.addChild(tile);
				}
			}
		}

		/* Tests functions */
		private function onTextureLoad(event:TextureHolderEvent):void{
			_ready = true;
			dispatchEvent(new TextureHolderEvent(TextureHolderEvent.TEXTURE_LOADED, event.url));
			const mapData:Array = [[10,9,9,9,9,10],
														[9,0,0,0,0,9],
														[9,0,0,0,0,9],
														[9,0,0,0,0,9],
														[9,0,0,0,0,9],
														[10,9,9,9,9,10]];
			createByMatrixArray(mapData, 6, 6);
		}
		
	}
}
