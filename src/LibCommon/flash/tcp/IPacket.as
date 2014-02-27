package flash.tcp
{
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;

	public interface IPacket
	{
		function create(msgId:uint=0, msgData:Object=null):IPacket;
		
		function get headSize():uint;
		function get bodySize():uint;
		
		function readHead(buffer:IDataInput):void;
		function readBody(buffer:IDataInput):void;
		
		function write(buffer:IDataOutput):void;
		
		function get msgId():uint;
		function get msgData():*;
	}
}