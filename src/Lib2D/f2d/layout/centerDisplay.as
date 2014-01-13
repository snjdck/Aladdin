package f2d.layout
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;

	public function centerDisplay(target:DisplayObject, parentWidth:Number, parentHeight:Number):void
	{
		var rect:Rectangle = target.getRect(target);
		centerViewX(target, parentWidth, -rect.x);
		centerViewY(target, parentHeight, -rect.y);
	}
}