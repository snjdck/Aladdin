package snjdck.fileformat.zip
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	final public class Zip
	{
		static private const file:ZipFile = new ZipFile();
		
		static public function Parse(zipBytes:ByteArray):Object
		{
			zipBytes.endian = Endian.LITTLE_ENDIAN;
			
			var result:Object = {};
			
			while(zipBytes.bytesAvailable > 0){
				if(zipBytes.readUnsignedInt() != 0x04034b50)
					break;
				file.read(zipBytes);
				result[file.getName()] = file.getData();
			}
			
			return result;
		}
	}
}