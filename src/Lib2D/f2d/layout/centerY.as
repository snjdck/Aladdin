package f2d.layout
{
	public function centerY(target:Object, targetHeight:Number, parentHeight:Number, offsetY:Number=0):void
	{
		assert(target.hasOwnProperty("y"));
		target.y = offsetY + 0.5 * (parentHeight - targetHeight);
	}
}