package flash.lang
{
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;

	public interface ISerializable
	{
		function readFromBuffer(buffer:IDataInput):void;
		function writeToBuffer(buffer:IDataOutput):void;
	}
}