package flash.system
{
	public function isMacOS():Boolean
	{
		return Capabilities.os.indexOf("Mac OS") == 0;
	}
}