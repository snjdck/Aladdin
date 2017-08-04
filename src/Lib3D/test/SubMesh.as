package test
{
	import flash.display3D.Context3D;
	
	import snjdck.gpu.asset.AssetMgr;
	import snjdck.gpu.asset.GpuIndexBuffer;
	import snjdck.gpu.asset.GpuVertexBuffer;
	import snjdck.gpu.asset.IGpuTexture;

	public class SubMesh implements IProgramVertexBufferContext, IProgramConstContext
	{
		private var vertexBuffer:GpuVertexBuffer;
		private var indexBuffer:GpuIndexBuffer;
		
		private const vertexFormatDict:Object = {};
		
		public function SubMesh(vertexFormatDict:Object, vertexBuffer:GpuVertexBuffer, indexBuffer:GpuIndexBuffer)
		{
			this.vertexBuffer = vertexBuffer;
			this.indexBuffer = indexBuffer;
			
			for(var key:String in vertexFormatDict){
				var info:Array = vertexFormatDict[key];
				this.vertexFormatDict[key] = new VertexBuffer3DInfo(vertexBuffer, info[0], info[1]);
			}
		}
		
		public function loadVertexBuffer(name:String, format:String):VertexBuffer3DInfo
		{
			var info:VertexBuffer3DInfo = vertexFormatDict[name];
			info.assertFormatEqual(format);
			return info;
		}
		
		public function loadConst(data:Vector.<Number>, name:String, fromRegister:int, toRegister:int):Boolean
		{
			return false;
		}
		
		public function draw(context3d:Context3D):void
		{
			context3d.drawTriangles(indexBuffer.getRawGpuAsset(context3d));
		}
	}
}