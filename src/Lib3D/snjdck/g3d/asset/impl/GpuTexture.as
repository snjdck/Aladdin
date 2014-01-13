package snjdck.g3d.asset.impl
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DTextureFormat;
	
	import math.isPowerOfTwo;
	
	import snjdck.g3d.asset.IGpuTexture;

	/** cube texture需要上传所有level的mipmap */
	final internal class GpuTexture extends GpuAsset implements IGpuTexture
	{
		public function GpuTexture(width:int, height:int, textureFormat:String=Context3DTextureFormat.BGRA)
		{
			var initName:String = isPowerOfTwo(width) && isPowerOfTwo(height) ? "createTexture" : "createRectangleTexture";
//			var initName:String = optimizeForRenderTarget ? "createRectangleTexture" : "createTexture";
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
		/*
		public function setRenderTarget(context3d:Context3D):void
		{
			if(false == initParams[3]){
				throw "texture must set 'optimizeForRenderTarget' to true!";
			}
			context3d.setRenderToTexture(getRawGpuAsset(context3d), true);
		}
		*/
	}
}