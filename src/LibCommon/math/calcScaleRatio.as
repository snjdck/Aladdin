package math
{
	public function calcScaleRatio(oldWidth:Number, oldHeight:Number, newWidth:Number, newHeight:Number):Number
	{
		return (newHeight / newWidth) >= (oldHeight / oldWidth) ? (newWidth / oldWidth) : (newHeight / oldHeight);
	}
}