package snjdck.g3d.asset
{
	public interface IGpuIndexBuffer extends IGpuAsset
	{
		function upload(data:Vector.<uint>, count:int=-1):void;
	}
}