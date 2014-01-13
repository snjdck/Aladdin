package f2d.layout
{
	/**
	 * result.x = alignRegionX(outer, inner, ratioX);
	 * <br/>
	 * result.y = alignRegionY(outer, inner, ratioY);
	 */
	public function alignRegion(outer:Object, inner:Object, result:Object, ratioX:Number=0.5, ratioY:Number=0.5):void
	{
		assert(result.hasOwnProperty("x"));
		result.x = alignRegionX(outer, inner, ratioX);
		
		assert(result.hasOwnProperty("y"));
		result.y = alignRegionY(outer, inner, ratioY);
	}
}