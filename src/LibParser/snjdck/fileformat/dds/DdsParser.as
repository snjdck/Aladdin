package snjdck.fileformat.dds
{
    import flash.display.BitmapData;
    import flash.utils.ByteArray;
    import flash.utils.Endian;
    import flash.utils.IDataInput;
    
    import tint.add;
    import tint.rgb555_to_argb8888;
    import tint.rgb565_to_argb8888;

    public class DdsParser
    {
        private const mColorBuf:Vector.<uint> = new Vector.<uint>(16, true);
        private const mAlphaBuf:Vector.<uint> = new Vector.<uint>(16, true);
        
        private var ddsFileHeader:DDSFileHeader;
        
        public function DdsParser(ddsfile:Class)
        {
            // 获取数据
            var bytes:ByteArray = new ddsfile();
            bytes.endian = Endian.LITTLE_ENDIAN;
            decode(bytes);
        }
        
        // 返回本模块是否能处理指定的格式信息
        private function canHandleThisFormat(header:DDSFileHeader) : Boolean
        {
            // 这些标记是必有的，否则认为图片格式不正确
            if (! (header.hasFlag(DDSFileHeader.DDSD_CAPS)) ||
                ! (header.hasFlag(DDSFileHeader.DDSD_HEIGHT)) ||
                ! (header.hasFlag(DDSFileHeader.DDSD_WIDTH)) ||
                ! (header.hasFlag(DDSFileHeader.DDSD_PIXELFORMAT)) ||
                ! (header.hasFlag(DDSFileHeader.DDSD_LINEARSIZE)))
                return false;
            
            // 只处理 DXT? 格式的，不处理其他非压缩格式
            if (! (header.ddpfPixelFormat.hasFlag(DDSPixelFormat.DDPF_FOURCC)))
                return false;
            
            // 只处理 DXT1, DXT3, DXT5
            var fmt:int = header.ddpfPixelFormat.getDXTFormat();
            if (fmt != DDSPixelFormat.DXT_1 && fmt != DDSPixelFormat.DXT_3 && fmt != DDSPixelFormat.DXT_5)
                return false;
            
            // 只处理Texture类型的，Cube map 和 Volume texture不支持
            return false == header.ddsCaps.hasFlag(DDSCaps2.DDSCAPS2_CUBEMAP | DDSCaps2.DDSCAPS2_VOLUME);
        }
        
        // 解码指定的内存段
        private function decode(data:ByteArray):void
        {
            if(data.readUTFBytes(4) != "DDS "){
                return;
			}
            ddsFileHeader = new DDSFileHeader();
            ddsFileHeader.read(data);
            
            // 检查是否能处理这样的格式
            if (! canHandleThisFormat(ddsFileHeader))
                return;
            
            // 取回DXT格式
            const dxtFmt:int = ddsFileHeader.ddpfPixelFormat.getDXTFormat();
			decodeMipMap(data, ddsFileHeader.width, ddsFileHeader.height, dxtFmt);
        }
        
        private function decodeMipMap(data:ByteArray, width:int, height:int, fmt:int):BitmapData
        {
			var bmdVec:Vector.<uint> = new Vector.<uint>(width*height, true);
            var blkw:int = Math.max(1, BLOCKNUM(width));
			var blkh:int = Math.max(1, BLOCKNUM(height));
            
            for(var row:int=0; row < blkh; row++)
            {
                for(var col:int=0; col < blkw; col++)
                {
					resetBuffer();
					decodeBlock(data, fmt);
					copyToDest(bmdVec, width, height, col << 2, row << 2);
                }
            }
			
			var bmd:BitmapData = new BitmapData(width, height, true, 0xFF000000);
			bmd.setVector(bmd.rect, bmdVec);
			return bmd;
        }
        
		private function resetBuffer():void
		{
			for(var i:int=0; i<16; i++){
				mColorBuf[i] = 0x00;
				mAlphaBuf[i] = 0xFF;
			}
		}
		
		private function copyToDest(bmd:Vector.<uint>, width:int, height:int, offsetX:int, offsetY:int):void
		{
			for(var row:int=0; row<4; row++)
			{
				for(var col:int=0; col<4; col++)
				{
					var x:int = offsetX + col;
					var y:int = offsetY + row;
					if(x >= width || y >= height){
						continue;
					}
					var globalIndex:int = y * width + x;
					var localIndex:int = row * 4 + col;
					bmd[globalIndex] = mColorBuf[localIndex];
				}
			}
		}
		
        private function decodeBlock(pblk:ByteArray, fmt:int):void
        {
            // 如果fmt指明是 DXT2-DXT5，需要先解码出alpha的信息
			switch(fmt)
			{
				case DDSPixelFormat.DXT_2:
				case DDSPixelFormat.DXT_3:
					decodeAlphaDXT3(pblk);
					break;
				case DDSPixelFormat.DXT_4:
				case DDSPixelFormat.DXT_5:
					decodeAlphaDXT5(pblk);
					break;
			}
            
            // 调色板中的四种颜色
            var colors:Vector.<uint> = new Vector.<uint>(4);
            var f3colorMode:Boolean = false;
            
            // 取两个调色的原始颜色
            var _color0:uint = pblk.readUnsignedShort();
            var _color1:uint = pblk.readUnsignedShort();
            
            // 计算出插值颜色
            if ((_color0 >= _color1) || fmt != DDSPixelFormat.DXT_1)
            {
                // _color0和_color1的格式为RGB 5:6:5。四色模式
                colors[0] = rgb565_to_argb8888(_color0);
                colors[1] = rgb565_to_argb8888(_color1);
                colors[2] = tint.add(tint.scale(colors[0], 2.0/3), tint.scale(colors[1], 1.0/3));
                colors[3] = tint.add(tint.scale(colors[0], 1.0/3), tint.scale(colors[1], 2.0/3));
            }
            else
            {
                // _color0和_color1的格式为RGBA 5:5:5:1。三色模式
                colors[0] = rgb555_to_argb8888(_color0);
                colors[1] = rgb555_to_argb8888(_color1);
                colors[2] = tint.add(tint.scale(colors[0], 1.0/2), tint.scale(colors[1], 1.0/2));
                colors[3] = 0x00; // 透明
                f3colorMode = true;
            }
            
			// 解码 (4 * 4) = 16 个像素
			for(var row:int=0; row<4; row++)
			{
				const byte:uint = pblk.readUnsignedByte();
				for(var col:int=0; col<4; col++)
				{
					var pixelIndex:int = col | (row << 2);
					var colorIndex:int = (byte >> (col << 1)) & 0x03;
					
					// 如果为三色模式，并且索引值为0b11，那么说明透明信息
					if (f3colorMode && colorIndex == 3){
						mAlphaBuf[pixelIndex] = 0x00;
					}else{// 其他情况，将调色板中的颜色保存下来
						mColorBuf[pixelIndex] = colors[colorIndex];
					}
					mColorBuf[pixelIndex] = (mColorBuf[pixelIndex] & 0xFFFFFF) | (mAlphaBuf[pixelIndex] << 24);
				}
			}
        }
        
        private function decodeAlphaDXT3(pblk:IDataInput):void
        {
			var pixelIndex:int = 0;
			for(var i:int=0; i<8; i++){
				const byte:uint = pblk.readUnsignedByte();
				mAlphaBuf[pixelIndex++] = byte & 0xF0;
				mAlphaBuf[pixelIndex++] = (byte & 0x0F) << 4;
			}
        }
            
        private function decodeAlphaDXT5(pblk:ByteArray):void
        {
            // alpha值查找表
            const alphas:Vector.<uint> = new Vector.<uint>(8, true);
            
            // 取到alpha_0和alpha_1
            alphas[0] = pblk.readUnsignedByte();
            alphas[1] = pblk.readUnsignedByte();
			
			const diff:int = alphas[0] - alphas[1];
			var i:int;
            
            if (diff > 0)
            {
                // 8-alpha mode
				for(i=1; i<7; i++){
					alphas[i+1] = alphas[0] + (3 - i * diff) / 7;
				}
            }
            else
            {
                // 6-alpha mode
				for(i=1; i<5; i++){
					alphas[i+1] = alphas[0] + (2 - i * diff) / 5;
				}
                alphas[6] = 0x00;
                alphas[7] = 0xFF;
            }
            
            // 解码4*4的alpha信息块
            var position:uint = pblk.position;
            for(i=0; i<16; i++)
            {
				var bitIndex:int = i * 3;
				var byteIndex:int = bitIndex >> 3;
				var offset:int = bitIndex & 0x07;
				
                pblk.position = position + byteIndex;
				var short:uint = pblk.readUnsignedByte() << 8;
				short |= pblk.readUnsignedByte();
				
				var alphaIndex:int = (short >> (13 - offset)) & 0x07;
                mAlphaBuf[i] = alphas[alphaIndex];
            }
            pblk.position = position + 6;
        }
        
        private static function BLOCKNUM(wh:int):int
        {
            return (wh + 3) >> 2;
        }
    }
}