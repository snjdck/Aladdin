package snjdck.g2d.texture
{
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import snjdck.g2d.core.ITexture2D;
	import snjdck.gpu.asset.IGpuTexture;

	public class Texture2D implements ITexture2D
	{
		private var _gpuTexture:IGpuTexture;
		protected const _frameMatrix:Matrix = new Matrix();
		protected const _uvMatrix:Matrix = new Matrix();
		
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
		
		public function get frameMatrix():Matrix
		{
			return _frameMatrix;
		}
		
		public function get uvMatrix():Matrix
		{
			return _uvMatrix;
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