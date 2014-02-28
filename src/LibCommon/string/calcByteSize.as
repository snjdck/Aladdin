package string
{
	/** 计算字符串的字节数 */
	public function calcByteSize(source:String):uint
	{
		if(null == source || source.length <= 0){
			return 0;
		}
		buffer.writeUTFBytes(source);
		var size:uint = buffer.length;
		buffer.clear();
		return size;
	}
}

import flash.utils.ByteArray;

const buffer:ByteArray = new ByteArray();