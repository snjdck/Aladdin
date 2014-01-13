package snjdck.media.sound
{
	import flash.utils.IDataOutput;

	public class StereoSample implements ISoundSample
	{
		private var sampleList:Vector.<Number>
		
		public function StereoSample(sampleList:Vector.<Number>)
		{
			this.sampleList = sampleList;
		}
		
		public function writeData(output:IDataOutput, position:int):void
		{
			var offset:int = position << 1;
			output.writeFloat(sampleList[offset]);
			output.writeFloat(sampleList[offset+1]);
		}
		
		public function get length():uint
		{
			return sampleList.length >> 1;
		}
	}
}