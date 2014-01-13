package math
{
	[Inline]
	public function sign(val:Number):int
	{
		return (val > 0) ? 1 : (val < 0 ? -1 : 0);
	}
}