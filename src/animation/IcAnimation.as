package animation {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.BitmapData;
	public class IcAnimation {
		public var frames:Vector.<BitmapData>;
		public var duration:Number; //in frames
		public var name:String;
		
		private var _maxFrames:uint;
		private var _currentFrame:uint;
		private var _bitmapData:BitmapData;
		
		public function IcAnimation(name:String, duration:Number, frames:Vector.<BitmapData>):void {
			this.name = name;
			this.duration = duration;
			this.frames = frames;
			_currentFrame = 0;
			if (frames) { _maxFrames = frames.length-1; }
			initBitmap();
		}
		
		public function get bitmapData():BitmapData {
			return _bitmapData;
		}
		
		public function get currentFrame():uint { return _currentFrame; }
		public function set currentFrame(value:uint):void {
			if (value == _currentFrame) { return; }
			_currentFrame = value < _maxFrames ? value : 0;
			updateBitmapData();
		}
		
		public function addFrame(frame:BitmapData):void {
			if (!frames) { frames = new Vector.<BitmapData>(); }
			frames.push(frame);
		}
		
		/* Internal functions */
		
		private function initBitmap():void {
			if (frames && frames.length > 0) {
				const firstFrame:BitmapData = frames[0];
				_bitmapData = new BitmapData(firstFrame.width, firstFrame.height, true, 0);
				_bitmapData.copyPixels(firstFrame, new Rectangle(0,0,firstFrame.width, firstFrame.height), new Point(0,0));
			}
		}
		
		private function updateBitmapData():void {
			const frame:BitmapData = frames[_currentFrame];
			_bitmapData.copyPixels(frame, new Rectangle(0,0,frame.width, frame.height), new Point(0,0));
		}
	}
}
