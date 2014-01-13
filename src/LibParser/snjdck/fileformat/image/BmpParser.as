package snjdck.fileformat.image
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	public class BmpParser extends ImageParser
	{
		public function BmpParser(bin:ByteArray)
		{
			super(bin);
		}
		
		override protected function decodeImp():void
		{
			ba.position = fileOffset + 10;
			var offset:uint = ba.readUnsignedInt();
			
			if(ba.readUnsignedInt() != 40){
				trace("error bitmap header!");
			}
			
			var width:int = ba.readInt();
			var height:int = ba.readInt();
			
			if(height < 0){
				height = -height;
			}else{
				bottom2top = true;
			}
			
			ba.position += 2;
			var bitPerPixel:uint = ba.readUnsignedShort();//1,4,8,16,24,32
			var compression:uint = ba.readUnsignedInt();// 0(不压缩),1(BI_RLE8压缩类型)或2(BI_RLE4压缩类型)之一
			var imageSize:uint = ba.readUnsignedInt();
			
			ba.position = fileOffset + 54;
			
			if(bitPerPixel < 16){//有调色板
				var palette:Array = [];
				var n:int = 1 << bitPerPixel;
				for(var i:int=0; i<n; i++){
					palette[i] = readColor(32);
				}
			}
			
			if(bitPerPixel < 24 || compression > 0){
				trace("bmp not support!");
			}
			
			ba.position = fileOffset + offset;
			
			bmd = new BitmapData(width, height, 32 == bitPerPixel);
			readPixelData(bitPerPixel);
		}
	}
}