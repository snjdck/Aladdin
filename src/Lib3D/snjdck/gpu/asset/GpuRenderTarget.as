package snjdck.gpu.asset
{
	import flash.display3D.Context3DTextureFormat;
	
	import math.isPowerOfTwo;
	
	import snjdck.gpu.GpuColor;

	public class GpuRenderTarget extends GpuAsset implements IGpuTexture
	{
		public var enableDepthAndStencil:Boolean;
		public var antiAlias:int;
		internal var _hasCleared:Boolean;
		private const color:GpuColor = new GpuColor();
		
		/**
		 * @param antiAlias(0=none,1=low,2=middle,3=high,4=very_high)
		 */		
		public function GpuRenderTarget(width:int, height:int, textureFormat:String=Context3DTextureFormat.BGRA)
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
		
		public function get format():String
		{
			return initParams[2];
		}
		
		public function clear(context3d:GpuContext):void
		{
			context3d.clear(color.red, color.green, color.blue, color.alpha);
		}
		
		public function hasCleared():Boolean
		{
			return _hasCleared;
		}
		
		public function set backgroundColor(value:uint):void
		{
			color.value = value;
		}
		
		public function setRenderToSelfAndClear(context3d:GpuContext):void
		{
			context3d.renderTarget = this;
			context3d.clear(color.red, color.green, color.blue, color.alpha);
		}
	}
}