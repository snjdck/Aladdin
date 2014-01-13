package snjdck.g3d.asset.impl
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DTextureFormat;
	
	import math.isPowerOfTwo;
	
	import snjdck.g3d.asset.IGpuContext;
	import snjdck.g3d.asset.IGpuTexture;
	import snjdck.g3d.asset.IRenderTarget;
	import snjdck.g3d.asset.helper.GpuColor;

	public class GpuRenterTarget extends GpuAsset implements IGpuTexture, IRenderTarget
	{
		private const color:GpuColor = new GpuColor();
		
		public function GpuRenterTarget(width:int, height:int, textureFormat:String=Context3DTextureFormat.BGRA)
		{
			var initName:String = isPowerOfTwo(width) && isPowerOfTwo(height) ? "createTexture" : "createRectangleTexture";
			super(initName, [width, height, textureFormat, true]);
		}
		
		public function get width():int
		{
			return initParams[0];
		}
		
		public function get height():int
		{
			return initParams[1];
		}
		
		public function onFrameBegin(context3d:IGpuContext):void
		{
		}
		
		public function setRenderTarget(context3d:Context3D):void
		{
			context3d.setRenderToTexture(getRawGpuAsset(context3d), true);
		}
		
		public function clear(context3d:IGpuContext):void
		{
			context3d.clear(color.red, color.green, color.blue, color.alpha);
		}
		
		public function set backgroundColor(value:uint):void
		{
			color.value = value;
		}
	}
}