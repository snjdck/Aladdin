package f2d
{
	import flash.display.DisplayObject;

	public function scaleTo(target:DisplayObject, scaleX:Number, scaleY:Number=NaN):void
	{
		target.scaleX = scaleX;
		target.scaleY = isNaN(scaleY) ? scaleX : scaleY;
	}
}