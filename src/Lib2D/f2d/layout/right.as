package f2d.layout
{
	public function right(target:Object, targetWidth:Number, parentWidth:Number, offsetX:Number=0):void
	{
		assert(target.hasOwnProperty("x"));
		target.x = offsetX + parentWidth - targetWidth;
	}
}