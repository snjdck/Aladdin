package f2d.layout
{
	public function center(target:Object, targetWidth:Number, targetHeight:Number, parentWidth:Number, parentHeight:Number, offsetX:Number=0, offsetY:Number=0):void
	{
		centerX(target, targetWidth, parentWidth, offsetX);
		centerY(target, targetHeight, parentHeight, offsetY);
	}
}