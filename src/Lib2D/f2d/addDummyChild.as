package f2d
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;

	public function addDummyChild(parent:DisplayObjectContainer):DisplayObject
	{
		return parent.addChild(new Shape());
	}
}