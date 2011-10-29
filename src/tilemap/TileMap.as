package tilemap {
	import flash.display.Sprite;
	import flash.geom.Point;

	public class TileMap extends Sprite {
		private var _tiles:Vector.<Vector.<Tile>>;
		private var _textureName:String;
		
		public function TileMap():void {
			super();
			createTextures();
		}
		
		public function canGoTo(point:Point):Boolean {
			if (pointInMap(point)) {
				const i:int = point.x / _tiles[0][0].width;
				const j:int = point.y / _tiles[0][0].height;
				return !_tiles[i][j].locked;
			}
			return false;
		}
		
		public function pointInMap(point:Point):Boolean {
			if (!_tiles || _tiles.length == 0 || _tiles[0].length == 0) { return false; }
			const i:int = point.x / _tiles[0][0].width;
			const j:int = point.y / _tiles[0][0].height;
			if (i < 0 || i > _tiles.length || j < 0 || j > _tiles[0].length) { return false; }
			return true;
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
