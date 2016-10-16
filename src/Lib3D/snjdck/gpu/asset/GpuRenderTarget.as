package snjdck.gpu.asset
{
	import flash.display3D.Context3DTextureFormat;
	
	import math.isPowerOfTwo;
	
	import snjdck.gpu.GpuColor;

	public class GpuRenderTarget extends GpuAsset implements IGpuTexture
	{
		public var enableDepthAndStencil:Boolean;
		public var antiAlias:int;
		private const color:GpuColor = new GpuColor();
		
		private var _width:int;
		private var _height:int;
		private var _format:String;
		
		/**
		 * @param antiAlias(0=none,1=low,2=middle,3=high,4=very_high)
		 */		
		public function GpuRenderTarget(width:int, height:int, textureFormat:String=Context3DTextureFormat.BGRA, isCube:Boolean=false)
		{
			_width = width;
			_height = height;
			_format = textureFormat;
			var initName:String = isCube ? "createCubeTexture" : (isPowerOfTwo(width) && isPowerOfTwo(height) ? "createTexture" : "createRectangleTexture");
			initParams = [width, height, textureFormat, true];
			if(isCube){
				initParams.removeAt(1);
			}
			super(initName, initParams);
		}

		public function get width():int
		{
			return _width;
		}
		
		public function get height():int
		{
			return _height;
		}
		
		public function get format():String
		{
			return _format;
		}
		
		public function clear(context3d:GpuContext):void
		{
			context3d.clear(color.red, color.green, color.blue, color.alpha);
		}
		
		public function set backgroundColor(value:uint):void
		{
			color.value = value;
		}
		
		public function setRenderToSelfAndClear(context3d:GpuContext, surfaceSelector:int=0):void
		{
			context3d.setRenderToTexture(this, surfaceSelector);
			context3d.clear(color.red, color.green, color.blue, color.alpha);
		}
	}
}