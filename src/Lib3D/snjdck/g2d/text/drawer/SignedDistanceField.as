package snjdck.g2d.text.drawer
{
	import flash.display.BitmapData;

	internal class SignedDistanceField
	{
		public function SignedDistanceField()
		{
		}
		
		public function gen(bmd:BitmapData):BitmapData
		{
			var newBmd:BitmapData = gen1(bmd);
			newBmd.lock();
			gen2(newBmd);
			gen3(newBmd);
			gen4(bmd, newBmd);
			newBmd.unlock();
			return newBmd;
		}
		
		private function gen1(bmd:BitmapData):BitmapData
		{
			var newBmd:BitmapData = new BitmapData(bmd.width, bmd.height, false, 0);
			for(var i:int=0; i<bmd.width; ++i){
				for(var j:int=0; j<bmd.height; ++j){
					var c0:uint = bmd.getPixel(i-1, j) & 0xFF;
					var c1:uint = bmd.getPixel(i+1, j) & 0xFF;
					var c2:uint = bmd.getPixel(i, j-1) & 0xFF;
					var c3:uint = bmd.getPixel(i, j+1) & 0xFF;
					var color:uint = bmd.getPixel(i, j) & 0xFF;
					if(color != c0 || color != c1 || color != c2 || color != c3){
						newBmd.setPixel(i, j, 0xFFFFFF);
					}
				}
			}
			return newBmd;
		}
		
		private var d1:Number = 256 / 16;
		private var d2:Number = d1 * 1.414;
		
		private function gen2(bmd:BitmapData):void
		{
			for(var i:int=0; i<bmd.width; ++i){
				for(var j:int=0; j<bmd.height; ++j){
					var c0:uint = bmd.getPixel(i-1, j-1) & 0xFF;
					var c1:uint = bmd.getPixel(i, j-1) & 0xFF;
					var c2:uint = bmd.getPixel(i+1, j-1) & 0xFF;
					var c3:uint = bmd.getPixel(i-1, j) & 0xFF;
					var color:uint = bmd.getPixel(i, j) & 0xFF;
					if(color < c0 - d2){
						color = c0 - d2;
					}
					if(color < c1 - d1){
						color = c1 - d1;
					}
					if(color < c2 - d2){
						color = c2 - d2;
					}
					if(color < c3 - d1){
						color = c3 - d1;
					}
					bmd.setPixel(i, j, color | color << 8 | color << 16);
				}
			}
		}
		
		
		private function gen3(bmd:BitmapData):void
		{
			for(var i:int=bmd.width-1; i>=0; --i){
				for(var j:int=bmd.height-1; j>=0; --j){
					var c0:uint = bmd.getPixel(i-1, j+1) & 0xFF;
					var c1:uint = bmd.getPixel(i, j+1) & 0xFF;
					var c2:uint = bmd.getPixel(i+1, j+1) & 0xFF;
					var c3:uint = bmd.getPixel(i+1, j) & 0xFF;
					var color:uint = bmd.getPixel(i, j) & 0xFF;
					if(color < c0 - d2){
						color = c0 - d2;
					}
					if(color < c1 - d1){
						color = c1 - d1;
					}
					if(color < c2 - d2){
						color = c2 - d2;
					}
					if(color < c3 - d1){
						color = c3 - d1;
					}
					bmd.setPixel(i, j, color | color << 8 | color << 16);
				}
			}
		}
		
		private function gen4(bmd:BitmapData, newBmd:BitmapData):void
		{
			for(var i:int=0; i<bmd.width; ++i){
				for(var j:int=0; j<bmd.height; ++j){
					var color:uint = bmd.getPixel(i, j) & 0xFF;
					if(color > 0x80){
						newBmd.setPixel(i, j, 0xFFFFFF);
					}
				}
			}
		}
	}
}