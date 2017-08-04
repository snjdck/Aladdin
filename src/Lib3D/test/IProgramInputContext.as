package test
{
	import snjdck.gpu.asset.IGpuTexture;

	public interface IProgramInputContext
	{
		function loadVertexBuffer(name:String, format:String):VertexBuffer3DInfo;
		function loadTexture(name:String):IGpuTexture;
	}
}