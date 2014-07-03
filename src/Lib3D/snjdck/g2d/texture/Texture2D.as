package snjdck.g2d.texture
{
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import matrix33.compose;
	
	import snjdck.g2d.support.VertexData;
	import snjdck.gpu.asset.IGpuTexture;
	import snjdck.g2d.core.ITexture2D;

	public class Texture2D implements ITexture2D
	{
		private var _gpuTexture:IGpuTexture;
		private var _frame:Rectangle;
		private var _frameMatrix:Matrix;
		
		public function Texture2D(gpuTexture:IGpuTexture=null)
		{
			_gpuTexture = gpuTexture;
		}
		
		public function get width():int
		{
			return _gpuTexture.width;
		}
		
		public function get height():int
		{
			return _gpuTexture.height;
		}
		
		public function get frame():Rectangle
		{
			return _frame;
		}
		
		public function set frame(val:Rectangle):void
		{
			_frame = val;
			
			if(null == _frame){
				return;
			}
			
			if(null == _frameMatrix){
				_frameMatrix = new Matrix();
			}
			
			compose(_frameMatrix, width/_frame.width, height/_frame.height, 0, -_frame.x, -_frame.y);
		}
		
		public function adjustVertexData(vertexData:VertexData):void
		{
			if(_frameMatrix != null){
				vertexData.transformPosition(_frameMatrix);
			}
		}
		
		public function get gpuTexture():IGpuTexture
		{
			return _gpuTexture;
		}
		
		public function set gpuTexture(value:IGpuTexture):void
		{
			_gpuTexture = value;
		}
		
		public function createSubTexture(region:Rectangle=null):SubTexture2D
		{
			return new SubTexture2D(this, region);
		}
	}
}