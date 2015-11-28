package snjdck.g2d.text.drawer
{
	import flash.display.BitmapData;

	public class SignedDistanceField
	{
		private var d1:Number;
		private var d2:Number;
		
		public function SignedDistanceField(spread:Number=4)
		{
			d1 = 256 / spread;
			d2 = d1 * Math.SQRT2;
		}
		
		public function gen(bmd:BitmapData):BitmapData
		{
			var newBmd:BitmapData = new BitmapData(bmd.width, bmd.height, false, 0);
			newBmd.lock();
			gen1(bmd, newBmd);
			gen2(newBmd);
			gen3(newBmd);
			gen4(bmd, newBmd);
			newBmd.unlock();
			return newBmd;
		}
		
		private function gen1(bmd:BitmapData, newBmd:BitmapData):void
		{
			for(var i:int=0; i<bmd.width; ++i){
				for(var j:int=0; j<bmd.height; ++j){
					if(bmd.getPixel(i, j) == 0){
						continue;
					}
					switch(0){
						case bmd.getPixel(i-1, j):
						case bmd.getPixel(i+1, j):
						case bmd.getPixel(i, j-1):
						case bmd.getPixel(i, j+1):
							newBmd.setPixel(i, j, 0xFFFFFF);
					}
				}
			}
		}
		
		private function gen2(bmd:BitmapData):void
		{
			for(var i:int=0; i<bmd.width; ++i){
				for(var j:int=0; j<bmd.height; ++j){
					updateColor(bmd, i, j,
						0xFF & bmd.getPixel(i-1, j-1),
						0xFF & bmd.getPixel(i,   j-1),
						0xFF & bmd.getPixel(i+1, j-1),
						0xFF & bmd.getPixel(i-1, j)
					);
				}
			}
		}
		
		
		private function gen3(bmd:BitmapData):void
		{
			for(var i:int=bmd.width-1; i>=0; --i){
				for(var j:int=bmd.height-1; j>=0; --j){
					updateColor(bmd, i, j,
						0xFF & bmd.getPixel(i-1, j+1),
						0xFF & bmd.getPixel(i,   j+1),
						0xFF & bmd.getPixel(i+1, j+1),
						0xFF & bmd.getPixel(i+1, j)
					);
				}
			}
		}
		
		private function gen4(bmd:BitmapData, newBmd:BitmapData):void
		{
			for(var i:int=0; i<bmd.width; ++i){
				for(var j:int=0; j<bmd.height; ++j){
					if(bmd.getPixel(i, j) > 0){
						newBmd.setPixel(i, j, 0xFFFFFF);
					}
				}
			}
		}
		
		private function updateColor(bmd:BitmapData, i:int, j:int, c0:uint, c1:uint, c2:uint, c3:uint):void
		{
			var color:uint = bmd.getPixel(i, j) & 0xFF;
			if(color < c0 - d2)
				color = c0 - d2;
			if(color < c1 - d1)
				color = c1 - d1;
			if(color < c2 - d2)
				color = c2 - d2;
			if(color < c3 - d1)
				color = c3 - d1;
			bmd.setPixel(i, j, color | color << 8 | color << 16);
		}
	}
}