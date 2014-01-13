package stdlib.bitmapdata
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public function bmd_split(source:BitmapData, hNum:int, vNum:int=1):Array
	{
		if(1 == hNum && 1 == vNum){
			return [source.clone()];
		}
		
		const list:Array = [];
		
		const w:int = source.width / hNum;
		const h:int = source.height / vNum;
		
		const sourceRect:Rectangle = new Rectangle(0, 0, w, h);
		const destPoint:Point = new Point(0, 0);
		
		for(var vIndex:int=0; vIndex<vNum; vIndex++)
		{
			for(var hIndex:int=0; hIndex<hNum; hIndex++)
			{
				var data:BitmapData = new BitmapData(w, h, true, 0);
				data.copyPixels(source, sourceRect, destPoint);
				list.push(data);
				//
				sourceRect.x += w;
			}
			sourceRect.x = 0;
			sourceRect.y += h;
		}
		
		return list;
	}
}