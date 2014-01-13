package f2d.layout
{
	/** @return ratio x (outer.width - inner.width) */
	public function alignRegionX(outer:Object, inner:Object, ratio:Number=0.5):Number
	{
		assert(outer.hasOwnProperty("width"));
		assert(inner.hasOwnProperty("width"));
		return ratio * (outer.width - inner.width);
	}
}