package f2d.layout
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;

	public function centerDisplayY(target:DisplayObject, parentHeight:Number):void
	{
		var rect:Rectangle = target.getRect(target);
		centerViewY(target, parentHeight, -rect.y);
	}
}