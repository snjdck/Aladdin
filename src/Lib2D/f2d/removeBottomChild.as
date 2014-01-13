package f2d
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public function removeBottomChild(parent:DisplayObjectContainer):DisplayObject
	{
		return parent.removeChildAt(0);
	}
}