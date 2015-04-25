package flash.system
{
	public function IsPlayerVersionHigherThan(majorVersion:int, minorVersion:int=0):Boolean
	{
		var versionStr:String = Capabilities.version.split(" ")[1];
		var version:Array = versionStr.split(",");
		var major:int = parseInt(version[0]);
		if(major > majorVersion){
			return true;
		}
		if(major < majorVersion){
			return false;
		}
		return parseInt(version[1]) >= minorVersion;
	}
}