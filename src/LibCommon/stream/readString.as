package stream
{
	import flash.utils.ByteArray;

	public function readString(buffer:ByteArray, end:uint=0, charSet:String="gb2312"):String
	{
		var index:int = buffer.position;
		
		while(buffer[index] != end){
			++index;
		}
		
		if(index > buffer.position){
			var str:String = buffer.readMultiByte(index - buffer.position, charSet);
			buffer.position = index + 1;
			return str;
		}
		
		return null;
	}
}