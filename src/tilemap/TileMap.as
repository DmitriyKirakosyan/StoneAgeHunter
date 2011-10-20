package tilemap {
	import flash.display.Sprite;
	public class TileMap extends Sprite {
		private var _tiles:Vector.<Vector.<Tile>>;
		private var _textureName:String;
		
		public function TileMap():void {
			super();
			createTextures();
		}
		
		/* Tests functions */
		
		private function setTilePosition(tile:Tile, i:int, j:int):void {
			tile.x = i * tile.width;
			tile.y = j * tile.height;
		}
		
		private function createTextures():void{
			const mapData:Array = [[0,0,0,0,0,0,0,0,0],
														 [0,0,0,0,0,0,0,0,0],
														 [0,0,0,0,0,1,0,0,0],
														 [0,0,0,0,1,0,0,0,0],
														 [0,0,0,1,0,0,0,0,0],
														 [0,0,0,0,0,0,0,0,0]];
			createByMatrixArray(mapData, 9, 6);
		}
		
		private function createByMatrixArray(matrix:Array, width:uint, height:uint):void {
			_tiles = new Vector.<Vector.<Tile>>();
			var tile:Tile;
			for (var i:int = 0; i < width; ++i) {
				_tiles[i] = new Vector.<Tile>();
				for (var j:int = 0; j < height; ++j) {
					tile = new Tile(matrix[j][i]);
					setTilePosition(tile, i, j);
					_tiles[i].push(tile);
					this.addChild(tile);
				}
			}
		}
		
	}
}
