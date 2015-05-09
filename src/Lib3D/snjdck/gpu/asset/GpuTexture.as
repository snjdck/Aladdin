package snjdck.gpu.asset
{
	import flash.display.BitmapData;
	import flash.display3D.Context3DTextureFormat;
	import flash.utils.ByteArray;
	
	import math.isPowerOfTwo;

	/** cube texture需要上传所有level的mipmap */
	final public class GpuTexture extends GpuAsset implements IGpuTexture
	{
		public var isOpaque:Boolean;
		
		private const uploadParams:Array = [];
		
		public function GpuTexture(width:int, height:int, textureFormat:String=Context3DTextureFormat.BGRA)
		{
			var initName:String = isPowerOfTwo(width) && isPowerOfTwo(height) ? "createTexture" : "createRectangleTexture";
			super(initName, [width, height, textureFormat, false]);
		}
		
		override public function dispose():void
		{
			super.dispose();
			uploadParams.splice(0);
		}
		
		public function upload(data:BitmapData):void
		{
			uploadParams[0] = data;
			uploadParams.splice(1);
			uploadImp("uploadFromBitmapData", uploadParams);
		}
		
		public function uploadATF(atfBytes:ByteArray, offset:int=0):void
		{
			uploadParams[0] = atfBytes;
			uploadParams[1] = offset;
			uploadImp("uploadCompressedTextureFromByteArray", uploadParams);
		}
		
		public function get width():int
		{
			return initParams[0];
		}
		
		public function get height():int
		{
			return initParams[1];
		}
		
		public function get format():String
		{
			return initParams[2];
		}
	}
}