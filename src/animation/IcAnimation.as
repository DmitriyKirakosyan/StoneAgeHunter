package animation {
	import flash.display.BitmapData;
	public class IcAnimation {
		public var frames:Vector.<BitmapData>;
		public var duration:Number;
		public var name:String;
		
		public function IcAnimation(name:String, duration:Number, frames:Vector.<BitmapData>):void {
			this.name = name;
			this.duration = duration;
			this.frames = frames;
		}
		
		public function addFrame(frame:BitmapData):void {
			if (!frames) { frames = new Vector.<BitmapData>(); }
			frames.push(frame);
		}
	}
}
