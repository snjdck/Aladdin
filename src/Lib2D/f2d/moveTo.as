package f2d
{
	import flash.display.DisplayObject;

	public function moveTo(target:DisplayObject, tx:Number, ty:Number=0):void
	{
		target.x = tx;
		target.y = ty;
	}
}