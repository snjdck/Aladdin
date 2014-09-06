package snjdck.g2d.core
{
	import flash.lang.IDimension;
	
	import snjdck.gpu.asset.IGpuTexture;

	public interface ITexture2D extends IDimension
	{
		function get gpuTexture():IGpuTexture;
	}
}