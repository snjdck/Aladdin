package flash.lang
{
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;

	public interface ISerializable
	{
		function readFrom(buffer:IDataInput):void;
		function writeTo(buffer:IDataOutput):void;
	}
}