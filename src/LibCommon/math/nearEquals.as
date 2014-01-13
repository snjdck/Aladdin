package math
{
	public function nearEquals(va:Number, vb:Number):Boolean
	{
		return Math.abs(va - vb) <= 0.00001;
	}
}