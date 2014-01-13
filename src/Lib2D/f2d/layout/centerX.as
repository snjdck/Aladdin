package f2d.layout
{
	public function centerX(target:Object, targetWidth:Number, parentWidth:Number, offsetX:Number=0):void
	{
		assert(target.hasOwnProperty("x"));
		target.x = offsetX + 0.5 * (parentWidth - targetWidth);
	}
}