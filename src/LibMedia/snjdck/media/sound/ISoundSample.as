package snjdck.media.sound
{
	import flash.utils.IDataOutput;

	public interface ISoundSample
	{
		function writeData(output:IDataOutput, position:int):void;
		function get length():uint;
	}
}