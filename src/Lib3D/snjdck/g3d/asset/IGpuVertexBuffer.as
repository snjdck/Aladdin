package snjdck.g3d.asset
{
	public interface IGpuVertexBuffer extends IGpuAsset
	{
		function upload(data:Vector.<Number>, numVertices:int=-1):void;
	}
}