package stream
{
	import flash.utils.ByteArray;

	public function readCString(buffer:ByteArray):String
	{
		return readString(buffer, 0xA);
	}
}