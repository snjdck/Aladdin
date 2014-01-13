package f2d.layout
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;

	public function centerDisplayX(target:DisplayObject, parentWidth:Number):void
	{
		var rect:Rectangle = target.getRect(target);
		centerViewX(target, parentWidth, -rect.x);
	}
}