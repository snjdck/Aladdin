package snjdck.fileformat.image
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	internal class ImageParser
	{
		protected var fileOffset:uint;
		protected var ba:ByteArray;
		protected var bmd:BitmapData;
		
		protected var right2left:Boolean;
		protected var bottom2top:Boolean;
		
		public function ImageParser(bin:ByteArray)
		{
			ba = bin;
			ba.endian = Endian.LITTLE_ENDIAN;
			fileOffset = ba.position;
		}
		
		final public function decode():BitmapData
		{
			if(null == bmd){
				decodeImp();
			}
			return bmd;
		}
		
		protected function decodeImp():void
		{
		}
		
		final protected function readPixelData(bitPerPixel:uint):void
		{
			var pixelCount:uint = bmd.width * bmd.height;
			for(var index:int=0; index<pixelCount; index++){
				setPixelAtIndex(index, readColor(bitPerPixel));
			}
		}
		
		final protected function setPixelAtIndex(index:uint, color:uint):void
		{
			var px:int = index % bmd.width;
			var py:int = index / bmd.width;
			
			if(right2left){
				px = bmd.width - 1 - px;
			}
			
			if(bottom2top){
				py = bmd.height - 1 - py;
			}
			
			bmd.setPixel32(px, py, color);
		}
		
		final protected function readColor(bitPerPixel:uint):uint
		{
			var color:uint = ba.readUnsignedByte();
			
			if(bitPerPixel > 8){
				color |= ba.readUnsignedByte() << 8;
			}
			
			if(bitPerPixel > 16){
				color |= ba.readUnsignedByte() << 16;
			}
			
			if(bitPerPixel > 24){
				color |= ba.readUnsignedByte() << 24;
			}
			
			return color;
		}
	}
}