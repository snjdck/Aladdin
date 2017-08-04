package test.materials
{
	import flash.display3D.Context3D;
	
	import snjdck.gpu.asset.IGpuTexture;
	
	import test.IProgramConstContext;
	import test.IProgramTextureContext;
	import test.ProgramInfoStack;
	import test.ProgramReader;
	import test.SubMesh;

	public class Material implements IMaterial, IProgramConstContext, IProgramTextureContext
	{
		public var shader:ProgramReader;
		
		public function Material(shader:ProgramReader=null)
		{
			this.shader = shader;
		}
		
		public function loadConst(data:Vector.<Number>, name:String, fromRegister:int, toRegister:int):Boolean
		{
			return false;
		}
		
		public function loadTexture(name:String):IGpuTexture
		{
			return null;
		}
		
		public function draw(context3d:Context3D, subMesh:SubMesh, contextStack:ProgramInfoStack):void
		{
			contextStack.pushConst(this);
			contextStack.pushTexture(this);
			shader.uploadConst(context3d, contextStack);
			shader.uploadFS(context3d, contextStack);
			shader.uploadVA(context3d, subMesh);
			contextStack.popConst();
			contextStack.popTexture();
			subMesh.draw(context3d);
		}
	}
}