package f2d.layout
{
	public function bottomRight(target:Object, targetWidth:Number, targetHeight:Number, parentWidth:Number, parentHeight:Number, offsetX:Number=0, offsetY:Number=0):void
	{
		bottom(target, targetHeight, parentHeight, offsetY);
		right(target, targetWidth, parentWidth, offsetX);
	}
}