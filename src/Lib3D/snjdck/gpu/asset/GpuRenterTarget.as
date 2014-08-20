package snjdck.gpu.asset
{
	import flash.display3D.Context3DTextureFormat;
	
	import math.isPowerOfTwo;
	
	import snjdck.gpu.GpuColor;

	public class GpuRenterTarget extends GpuAsset implements IGpuTexture, IGpuRenderTarget
	{
		private const color:GpuColor = new GpuColor();
		private var _antiAlias:int;
		
		/**
		 * @param antiAlias(0=none,1=low,2=middle,3=high,4=very_high)
		 */		
		public function GpuRenterTarget(width:int, height:int, textureFormat:String=Context3DTextureFormat.BGRA, antiAlias:int=0)
		{
			var initName:String = isPowerOfTwo(width) && isPowerOfTwo(height) ? "createTexture" : "createRectangleTexture";
			super(initName, [width, height, textureFormat, true]);
			this._antiAlias = antiAlias;
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
		
		public function get antiAlias():int
		{
			return _antiAlias;
		}
		
		public function setRenderToSelf(context3d:GpuContext):void
		{
			context3d.setRenderToTexture(this);
		}
		
		public function clear(context3d:GpuContext):void
		{
			context3d.clear(color.red, color.green, color.blue, color.alpha);
		}
		
		public function set backgroundColor(value:uint):void
		{
			color.value = value;
		}
	}
}