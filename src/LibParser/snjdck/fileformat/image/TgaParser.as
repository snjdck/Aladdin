package snjdck.fileformat.image
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;

	public class TgaParser extends ImageParser
	{
		public function TgaParser(bin:ByteArray)
		{
			super(bin);
		}
		
		override protected function decodeImp():void
		{
			var imageInfoSize:uint = ba.readUnsignedByte();
			var hasColorTable:Boolean = ba.readBoolean();
			var imageType:uint = ba.readUnsignedByte();
			
			if(hasColorTable){
				var colorTableOffset:uint = ba.readUnsignedShort();
				var colorTableLength:uint = ba.readUnsignedShort();
				var colorType:uint = ba.readUnsignedByte();//16,24,32
			}else{
				ba.position += 5;
			}
			
			var px:uint = ba.readUnsignedShort();
			var py:uint = ba.readUnsignedShort();
			var width:uint = ba.readUnsignedShort();
			var height:uint = ba.readUnsignedShort();
			
			var bitPerPixel:uint = ba.readUnsignedByte();//8, 16, 24, 32
			var flags:uint = ba.readUnsignedByte();
			/*--head end--*/
			
			right2left = ((flags >> 4) & 1) == 1;
			bottom2top = ((flags >> 5) & 1) == 0;
			
			ba.position += imageInfoSize;
			
			bmd = new BitmapData(width, height, 32 == bitPerPixel);
			
			switch(imageType){
				case 2://非压缩
					readPixelData(bitPerPixel);
					break;
				case 10://rle压缩,run-length encoded
					readType10(bitPerPixel);
					break;
				case 0://no image data
				case 1://非压缩,有调色板的图片
				case 3://非压缩,黑白图片
				case 9://rle,有调色板
				case 11://rle,黑白图片
				default:
					throw new Error("not support tga type:" + imageType);
			}
		}
		
		private function readType10(bitPerPixel:uint):void
		{
			var pixelCount:uint = bmd.width * bmd.height;
			var index:int = 0;
			
			var head:uint;
			var count:uint;
			var color:uint;
			
			while(index < pixelCount){
				head = ba.readUnsignedByte();
				if((head & 0x80) > 0){
					count = (head & 0x7F) + 1;
					color = readColor(bitPerPixel);
					while(count-- > 0){
						setPixelAtIndex(index++, color);
					}
				}else{
					count = head + 1;
					while(count-- > 0){
						setPixelAtIndex(index++, readColor(bitPerPixel));
					}
				}
			}
		}
	}
}