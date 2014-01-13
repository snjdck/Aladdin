package snjdck.g3d.asset.impl
{
	import flash.display3D.Context3D;
	
	import snjdck.g3d.asset.IGpuContext;
	import snjdck.g3d.asset.IRenderTarget;
	import snjdck.g3d.asset.helper.GpuColor;

	public class GpuFrameBuffer implements IRenderTarget
	{
		private var prevContext3d:IGpuContext;
		private var _width:int;
		private var _height:int;
		private var _antiAlias:int;
		
		private const color:GpuColor = new GpuColor();
		
		public function GpuFrameBuffer(width:int, height:int, antiAlias:int=4)
		{
			this._width = width;
			this._height = height;
			this._antiAlias = antiAlias;
		}
		
		public function get width():int
		{
			return _width;
		}
		
		public function get height():int
		{
			return _height;
		}
		
		public function onFrameBegin(context3d:IGpuContext):void
		{
			if(prevContext3d != context3d){
				context3d.configureBackBuffer(_width, _height, _antiAlias, true);
				prevContext3d = context3d;
			}
		}
		
		public function setRenderTarget(context3d:Context3D):void
		{
			context3d.setRenderToBackBuffer();
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