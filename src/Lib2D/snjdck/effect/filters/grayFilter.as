package snjdck.effect.filters
{
	import flash.filters.BitmapFilter;
	import flash.filters.ColorMatrixFilter;

	/** 灰度滤镜 **/
	public const grayFilter:BitmapFilter = new ColorMatrixFilter([
		0.299, 0.587, 0.114, 0, 0,
		0.299, 0.587, 0.114, 0, 0,
		0.299, 0.587, 0.114, 0, 0,
		0, 0, 0, 1, 0
	]);
}