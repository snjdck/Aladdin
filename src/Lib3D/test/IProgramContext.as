package
{
	import flash.display3D.textures.TextureBase;

	public interface IProgramContext
	{
		function loadVertexBuffer(name:String):VertexBuffer3DInfo;
		function loadTexture(name:String):TextureBase;
		function loadConst(data:Vector.<Number>, name:String, fromRegister:int, toRegister:int):void;
	}
}