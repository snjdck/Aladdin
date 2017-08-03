package test
{
	import snjdck.gpu.asset.IGpuTexture;

	public interface IProgramContext
	{
		function loadVertexBuffer(name:String, format:String):VertexBuffer3DInfo;
		function loadTexture(name:String):IGpuTexture;
		function loadConst(data:Vector.<Number>, name:String, fromRegister:int, toRegister:int):void;
	}
}