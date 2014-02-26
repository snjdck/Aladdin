package flash.filesystem
{
	import flash.utils.ByteArray;
	
	import string.removeSpace;
	
	final public class FileEncrypt
	{
		static public function XOR(input:ByteArray, output:ByteArray, key:Array, bytePerChunk:uint=0xFFFFFFFF):void
		{
			var keyCount:uint = key.length;
			for(var i:int=0, n:int=input.length; i<n; i++){
				output[i] = input[i] ^ key[i%bytePerChunk%keyCount];
			}
		}
		
		static public function ParseKey(key:String):Array
		{
			key = removeSpace(key);
			var result:Array = [];
			for(var i:int=0, n:int=key.length; i<n; i+=2){
				result.push(parseInt(key.substr(i,2), 16));
			}
			return result;
		}
	}
}