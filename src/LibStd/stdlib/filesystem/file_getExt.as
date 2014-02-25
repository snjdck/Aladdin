package filesystem
{
	public function file_getExt(filePath:String):String
	{
		var index:int = filePath.lastIndexOf(".");
		if(-1 != index){
			return filePath.slice(index+1);
		}
		return null;
	}
}