package flash.factory
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	/** 默认为Endian.LITTLE_ENDIAN */
	public function newBuffer(endian:String=null, size:uint=0):ByteArray
	{
		var ba:ByteArray = new ByteArray();
		ba.endian = (Endian.BIG_ENDIAN == endian) ? Endian.BIG_ENDIAN : Endian.LITTLE_ENDIAN;
		ba.length = size;
		return ba;
	}
}