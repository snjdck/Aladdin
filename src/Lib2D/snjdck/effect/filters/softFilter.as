package snjdck.effect.filters
{
	import flash.filters.BitmapFilter;
	import flash.filters.ConvolutionFilter;

	/** 柔化滤镜 **/
	public const softFilter:BitmapFilter = new ConvolutionFilter(
		3, 3, [
			1, 1, 1,
			1, 1, 1,
			1, 1, 1
		], 9
	);
}