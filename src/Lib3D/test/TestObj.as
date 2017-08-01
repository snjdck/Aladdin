package
{
	import flash.display3D.Context3D;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.textures.TextureBase;

	public class TestObj implements IProgramContext
	{
		private var buffer:VertexBuffer3DInfo;
		private var indexBuffer:IndexBuffer3D;
		public var program:ProgramReader;
		
		public function TestObj(context3d:Context3D)
		{
			var buffer:VertexBuffer3D = context3d.createVertexBuffer(3, 3);
			buffer.uploadFromVector(new <Number>[-1, -1, 0, 1, -1, 0, 0, 1, 0], 0, 3);
			this.buffer = new VertexBuffer3DInfo(buffer);
			
			indexBuffer = context3d.createIndexBuffer(3);
			indexBuffer.uploadFromVector(new <uint>[0, 1, 2], 0, 3);
		}
		
		public function loadConst(data:Vector.<Number>, name:String, fromRegister:int, toRegister:int):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function loadTexture(name:String):TextureBase
		{
			// TODO Auto Generated method stub
			return null;
		}
		
		public function loadVertexBuffer(name:String):VertexBuffer3DInfo
		{
			if(name == "position"){
				return buffer;
			}
			return null;
		}
		
		public function draw(context3d:Context3D):void
		{
			program.upload(context3d, this);
			context3d.drawTriangles(indexBuffer);
		}
	}
}