package flash.filters
{
	/** 柔化滤镜 **/
	public const softFilter:BitmapFilter = new ConvolutionFilter(
		3, 3, [
			1, 1, 1,
			1, 1, 1,
			1, 1, 1
		], 9
	);
}