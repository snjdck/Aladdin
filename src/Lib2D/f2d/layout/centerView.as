package f2d.layout
{
	public function centerView(target:Object, parentWidth:Number, parentHeight:Number, offsetX:Number=0, offsetY:Number=0):void
	{
		centerViewX(target, parentWidth, offsetX);
		centerViewY(target, parentHeight, offsetY);
	}
}