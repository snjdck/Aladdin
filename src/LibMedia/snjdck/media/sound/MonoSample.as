package snjdck.media.sound
{
	import flash.utils.IDataOutput;

	public class MonoSample implements ISoundSample
	{
		private var sampleList:Vector.<Number>
		
		public function MonoSample(sampleList:Vector.<Number>)
		{
			this.sampleList = sampleList;
		}
		
		public function writeData(output:IDataOutput, position:int):void
		{
			var value:Number = sampleList[position];
			output.writeFloat(value);
			output.writeFloat(value);
		}
		
		public function get length():uint
		{
			return sampleList.length;
		}
	}
}