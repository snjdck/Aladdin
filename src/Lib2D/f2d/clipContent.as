package f2d
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;

	public function clipContent(target:DisplayObject, width:Number, height:Number, x:Number=0, y:Number=0):void
	{
		target.scrollRect = new Rectangle(x, y, width, height);
	}
}