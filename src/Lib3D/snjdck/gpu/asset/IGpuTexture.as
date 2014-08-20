package snjdck.gpu.asset
{
	import flash.lang.IDimension;

	public interface IGpuTexture extends IGpuAsset, IDimension
	{
		function get format():String;
	}
}