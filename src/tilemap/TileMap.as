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
					this.addChild(tile);
				}
			}
		}

		/* Tests functions */
		private function onTextureLoad(event:TextureHolderEvent):void{
			_ready = true;
			dispatchEvent(new TextureHolderEvent(TextureHolderEvent.TEXTURE_LOADED, event.url));
			const mapData:Array = [[0,0,0], [0,0,0], [0,0,0]];
			createByMatrixArray(mapData, 3, 3);
		}
		
	}
}
