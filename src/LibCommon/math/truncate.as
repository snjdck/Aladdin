package math
{
	public function truncate(value:Number, range1:Number=0, range2:Number=1):Number
	{
		var min:Number = range1 <= range2 ? range1 : range2;
		var max:Number = range1 >= range2 ? range1 : range2;
		return (value <= min) ? min : (value >= max ? max : value);
	}
}