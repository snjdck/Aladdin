package f2d.layout
{
	/** @return ratio x (outer.height - inner.height) */
	public function alignRegionY(outer:Object, inner:Object, ratio:Number=0.5):Number
	{
		assert(outer.hasOwnProperty("height"));
		assert(inner.hasOwnProperty("height"));
		return ratio * (outer.height - inner.height);
	}
}