package f2d
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public function removeTopChild(parent:DisplayObjectContainer):DisplayObject
	{
		return parent.removeChildAt(parent.numChildren-1);
	}
}