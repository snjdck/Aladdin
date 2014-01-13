package f2d
{
	import flash.display.DisplayObjectContainer;

	public function setEnable(target:DisplayObjectContainer, value:Boolean):void
	{
		target.mouseEnabled = target.mouseChildren = value;
	}
}