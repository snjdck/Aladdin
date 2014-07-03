package snjdck.g2d.core
{
	import flash.lang.IDimension;
	
	import snjdck.g2d.support.VertexData;
	import snjdck.gpu.asset.IGpuTexture;

	public interface ITexture2D extends IDimension
	{
		function get gpuTexture():IGpuTexture;
		function adjustVertexData(vertexData:VertexData):void;
	}
}