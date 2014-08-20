package snjdck.gpu.asset
{
	import flash.display.BitmapData;
	import flash.display3D.Context3DTextureFormat;
	
	import math.isPowerOfTwo;

	/** cube texture需要上传所有level的mipmap */
	final internal class GpuTexture extends GpuAsset implements IGpuTexture
	{
		public function GpuTexture(width:int, height:int, textureFormat:String=Context3DTextureFormat.BGRA)
		{
			var initName:String = isPowerOfTwo(width) && isPowerOfTwo(height) ? "createTexture" : "createRectangleTexture";
			super(initName, [width, height, textureFormat, false]);
		}
		
		public function upload(data:BitmapData):void
		{
			uploadImp("uploadFromBitmapData", data);
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