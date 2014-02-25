package filesystem
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	final public class FileIO
	{
		static private const fs:FileStream = new FileStream();
		
		static public function Read(fileOrPath:*, output:ByteArray=null):ByteArray
		{
			var file:File = (fileOrPath is File) ? fileOrPath : new File(fileOrPath);
			if(!file.exists){
				return null;
			}
			
			output ||= new ByteArray();
			
			fs.open(file, FileMode.READ);
			fs.readBytes(output);
			fs.close();
			
			return output;
		}
		
		static public function Write(fileOrPath:*, data:ByteArray):void
		{
			var file:File = (fileOrPath is File) ? fileOrPath : new File(fileOrPath);
			fs.open(file, FileMode.WRITE);
			fs.writeBytes(data);
			fs.close();
		}
		
		static public function Traverse(fileOrPath:*, handler:Function):void
		{
			var file:File = (fileOrPath is File) ? fileOrPath : new File(fileOrPath);
			if(false == file.isDirectory){
				handler(file);
				return;
			}
			for each(var subFile:File in file.getDirectoryListing()){
				arguments.callee(subFile, handler);
			}
		}
	}
}