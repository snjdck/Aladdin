package test
{
	import flash.display3D.Context3D;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.textures.TextureBase;
	
	import snjdck.gpu.asset.GpuIndexBuffer;
	import snjdck.gpu.asset.GpuVertexBuffer;
	import snjdck.gpu.support.GpuConstData;

	public class TestObj implements IProgramContext
	{
		private var buffer:VertexBuffer3DInfo;
		private var indexBuffer:GpuIndexBuffer;
		public var program:ProgramReader;
		
		public function TestObj(context3d:Context3D)
		{
			var buffer:GpuVertexBuffer = new GpuVertexBuffer(3, 3);
			buffer.upload(new <Number>[-1, -1, 0, 1, -1, 0, 0, 1, 0]);
//			var buffer:VertexBuffer3D = context3d.createVertexBuffer(3, 3);
//			buffer.uploadFromVector(new <Number>[-1, -1, 0, 1, -1, 0, 0, 1, 0], 0, 3);
			this.buffer = new VertexBuffer3DInfo(buffer);
			
			indexBuffer = new GpuIndexBuffer(3);
			indexBuffer.upload(new <uint>[0, 1, 2]);
		}
		
		public function loadConst(data:Vector.<Number>, name:String, fromRegister:int, toRegister:int):void
		{
			// TODO Auto Generated method stub
//			GpuConstData.SetNumber(
		}
		
		public function loadTexture(name:String):TextureBase
		{
			// TODO Auto Generated method stub
			return null;
		}
		
		public function loadVertexBuffer(name:String):VertexBuffer3DInfo
		{
			switch(name){
				case "position": return buffer;
			}
			return null;
		}
		
		public function draw(context3d:Context3D):void
		{
			program.upload(context3d, this);
			context3d.drawTriangles(indexBuffer.getRawGpuAsset(context3d));
		}
	}
}