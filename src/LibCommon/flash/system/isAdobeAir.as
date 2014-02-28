package flash.system
{
	public function isAdobeAir():Boolean
	{
		return "Desktop" == Capabilities.playerType;
	}
}