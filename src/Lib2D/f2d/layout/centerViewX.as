package f2d.layout
{
	public function centerViewX(target:Object, parentWidth:Number, offsetX:Number=0):void
	{
		assert(target.hasOwnProperty("width"));
		centerX(target, target.width, parentWidth, offsetX);
	}
}