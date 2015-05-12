package flash.system
{
	import string.has;

	public function IsMobile():Boolean
	{
		var os:String = Capabilities.os.toLowerCase();
		return has(os, "iphone") || has(os, "android");
	}
}