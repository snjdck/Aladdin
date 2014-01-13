package system
{
	import flash.system.Capabilities;

	public function isAdobeAir():Boolean
	{
		return "Desktop" == Capabilities.playerType;
	}
}