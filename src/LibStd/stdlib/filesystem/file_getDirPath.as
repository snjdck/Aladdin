package stdlib.filesystem
{
	/**
	 * 获取文件路径的目录地址<br>
	 * http://www.web.com/login.php?name=admin 返回 http://www.web.com/
	 */
	public function file_getDirPath(filePath:String):String
	{
		var result:String = filePath;
		
		var index:int = result.indexOf("?");
		if(index != -1){
			result = result.slice(0, index);
		}
		
		index = result.lastIndexOf("/");
		if(index != -1){
			result = result.slice(0, index+1);
		}else{
			result = "";
		}
		
		return result;
	}
}