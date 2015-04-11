package snjdck.g2d.core
{
	import flash.geom.Matrix;
	import flash.lang.IDimension;
	
	import snjdck.gpu.asset.IGpuTexture;

	public interface ITexture2D extends IDimension
	{
		function get gpuTexture():IGpuTexture;
		function get frameMatrix():Matrix;
		function get uvMatrix():Matrix;
		function get scale9():Vector.<Number>;
	}
}