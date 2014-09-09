package snjdck.g2d.impl
{
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import snjdck.g2d.core.ITexture2D;
	import snjdck.gpu.asset.IGpuTexture;

	public class Texture2D implements ITexture2D
	{
		private var _gpuTexture:IGpuTexture;
		
		private const _frameMatrix:Matrix = new Matrix();
		private const _uvMatrix:Matrix = new Matrix();
		
		private var _frame:Rectangle;
		private var _region:Rectangle;
		
		public function Texture2D(gpuTexture:IGpuTexture=null)
		{
			_gpuTexture = gpuTexture;
		}
		
		public function get width():int
		{
			if(_frame != null){
				return _frame.width;
			}
			if(_region != null){
				return _region.width;
			}
			return _gpuTexture.width;
		}
		
		public function get height():int
		{
			if(_frame != null){
				return _frame.height;
			}
			if(_region != null){
				return _region.height;
			}
			return _gpuTexture.height;
		}
		
		public function get gpuTexture():IGpuTexture
		{
			return _gpuTexture;
		}
		
		public function set gpuTexture(value:IGpuTexture):void
		{
			_gpuTexture = value;
		}
		
		public function get frameMatrix():Matrix
		{
			return _frameMatrix;
		}
		
		public function get uvMatrix():Matrix
		{
			return _uvMatrix;
		}
		
		public function set frame(value:Rectangle):void
		{
			_frame = value;
			
			if(null == _frame){
				_frameMatrix.identity();
				return;
			}
			
			_frameMatrix.a = _region.width / _frame.width;
			_frameMatrix.d = _region.height / _frame.height;
			_frameMatrix.tx = -_frame.x;
			_frameMatrix.ty = -_frame.y;
		}
		
		public function set region(value:Rectangle):void
		{
			_region = value;
			
			if(null == _region){
				_uvMatrix.identity();
				return;
			}
			
			_uvMatrix.setTo(_region.width, 0, 0, _region.height, _region.x, _region.y);
			_uvMatrix.scale(1/_gpuTexture.width, 1/_gpuTexture.height);
		}
	}
}