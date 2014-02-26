package flash.filters
{
	/** 像素反转滤镜 **/
	public const invertFilter:BitmapFilter = new ColorMatrixFilter([
		-1, 0, 0, 0, 255,
		0, -1, 0, 0, 255,
		0, 0, -1, 0, 255,
		0, 0, 0, 1, 0
	]);
}