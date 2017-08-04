package test
{
	import snjdck.gpu.asset.IGpuTexture;

	public interface IProgramTextureContext
	{
		function loadTexture(name:String):IGpuTexture;
	}
}