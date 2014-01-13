package stdlib.filesystem
{
	public function file_getName(filePath:String):String
	{
		var index:int = filePath.lastIndexOf(".");
		if(-1 != index){
			return filePath.slice(0, index);
		}
		return filePath;
	}
}