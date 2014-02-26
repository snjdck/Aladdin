package flash.bitmap
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 合并许多<b>同样大小</b>的小位图为一张大位图
	 * 
	 * @param list Array or Vector.&lt;BitmapData&gt;
	 * @param hNum 一行上放几张小位图
	 */
	public function mergeImage(list:Object, hNum:int=int.MAX_VALUE):BitmapData
	{
		const vNum:int = Math.ceil(list.length / hNum);
		
		var source:BitmapData = list[0];
		
		const w:int = source.width;
		const h:int = source.height;
		
		const sourceRect:Rectangle = new Rectangle(0, 0, w, h);
		const destPoint:Point = new Point();
		
		const output:BitmapData = new BitmapData(w*hNum, h*vNum, true, 0);
		
		for(var vIndex:int=0; vIndex<vNum; vIndex++)
		{
			for(var hIndex:int=0; hIndex<hNum; hIndex++)
			{
				source = list[vIndex*hNum+hIndex];
				output.copyPixels(source, sourceRect, destPoint);
				//
				destPoint.x += w;
			}
			destPoint.x = 0;
			destPoint.y += h;
		}
		
		return output;
	}
}