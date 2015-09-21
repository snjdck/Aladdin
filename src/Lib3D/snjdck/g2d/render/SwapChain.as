package snjdck.g2d.render
{
	import flash.lang.IDisposable;
	
	import snjdck.gpu.asset.GpuRenderTarget;

	public class SwapChain implements IDisposable
	{
		private var _frontBuffer:GpuRenderTarget;
		private var _backBuffer:GpuRenderTarget;
		
		public function SwapChain(width:int, height:int, passCount:int)
		{
			_frontBuffer = new GpuRenderTarget(width, height);
			if(passCount > 1){
				_backBuffer = new GpuRenderTarget(width, height);
			}
		}

		public function dispose():void
		{
			if(_frontBuffer != null){
				_frontBuffer.dispose();
				_frontBuffer = null;
			}
			if(_backBuffer != null){
				_backBuffer.dispose();
				_backBuffer = null;
			}
		}
		
		public function swap():void
		{
			var temp:GpuRenderTarget = frontBuffer;
			_frontBuffer = _backBuffer;
			_backBuffer = temp;
		}

		public function get frontBuffer():GpuRenderTarget
		{
			return _frontBuffer;
		}
		
		public function get backBuffer():GpuRenderTarget
		{
			return _backBuffer;
		}
	}
}