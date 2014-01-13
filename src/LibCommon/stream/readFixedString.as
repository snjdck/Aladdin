package stream
{
	import flash.utils.ByteArray;

	public function readFixedString(buffer:ByteArray, length:uint):String
	{
		var index:uint = buffer.position;
		var str:String = readString(buffer, 0);
		buffer.position = index + length;
		return str;
	}
}