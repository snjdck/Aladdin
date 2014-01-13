package snjdck.g3d.asset
{
	public interface IGpuProgram extends IGpuAsset
	{
		function getVaUseInfo():uint;
		function getFsUseInfo():uint;
	}
}