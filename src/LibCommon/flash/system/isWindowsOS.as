package flash.system
{
	public function isWindowsOS():Boolean
	{
		return Capabilities.os.indexOf("Windows") == 0;
	}
}