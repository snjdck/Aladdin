package f2d.layout
{
	public function centerViewY(target:Object, parentHeight:Number, offsetY:Number=0):void
	{
		assert(target.hasOwnProperty("height"));
		centerY(target, target.height, parentHeight, offsetY);
	}
}