package snjdck.utils
{
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	import stdlib.filesystem.FileIO;
	
	import string.removeSpace;

	//*/
	public class FileUtil
	{
		//*
		
		static public function XOR_BIN(input:ByteArray, output:ByteArray, key:String, bytePerChunk:uint=0xFFFFFFFF):void
		{
			var keyList:Array = ParseKey(key);
			for(var i:int=0, n:int=input.length; i<n; i++){
				output[i] = input[i] ^ keyList[i%bytePerChunk%keyList.length];
			}
		}
		
		static public function XOR_FILE(filePath:String, newFileName:String, key:String, bytePerChunk:uint=0xFFFFFFFF):void
		{
			var file:File = new File(filePath);
			
			var ba:ByteArray = FileIO.Read(file);
			
			XOR_BIN(ba, ba, key, bytePerChunk);
			
			file = file.resolvePath("../" + newFileName);
			
			if(file.exists){
				trace(file.nativePath, "文件已存在,写入失败!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
			}else{
				FileIO.Write(file, ba);
				trace(file.nativePath, "文件写入成功***************************************");
			}
		}
		//*/
		
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