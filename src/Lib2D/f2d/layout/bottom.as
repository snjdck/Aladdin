package f2d.layout
{
	public function bottom(target:Object, targetHeight:Number, parentHeight:Number, offsetY:Number=0):void
	{
		assert(target.hasOwnProperty("y"));
		target.y = offsetY + parentHeight - targetHeight;
	}
}