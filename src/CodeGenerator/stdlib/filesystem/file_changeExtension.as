package stdlib.filesystem
{
	import flash.filesystem.File;

	public function file_changeExtension(file:File, extension:String):File
	{
		var filePath:String = file.nativePath;
		var index:int = filePath.lastIndexOf(".");
		if(-1 != index){
			return new File(filePath.slice(0, index+1) + extension);
		}
		return file;
	}
}