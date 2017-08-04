package test
{
	import flash.display3D.Context3D;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import snjdck.g3d.core.Object3D;
	import snjdck.gpu.asset.GpuIndexBuffer;
	import snjdck.gpu.asset.GpuVertexBuffer;
	import snjdck.gpu.support.GpuConstData;
	
	import test.materials.ColorMaterial;

	public class ModelLoader extends Object3D implements IProgramConstContext
	{
		private var subMeshList:Array = [];
		private var vertexFormatDict:Object = {}
//		public var program:ProgramReader;
		public var material:ColorMaterial;
		
		public function ModelLoader()
		{
		}
		
		public function load(data:ByteArray):void
		{
			data.endian = Endian.LITTLE_ENDIAN;
			var vertexFormatCount:int = data.readUnsignedByte();
			for(var i:int=0; i<vertexFormatCount; ++i){
				vertexFormatDict[data.readUTFBytes(data.readUnsignedByte())] = [data.readUTFBytes(data.readUnsignedByte()), data.readUnsignedByte()];
			}
			var subMeshCount:int = data.readUnsignedShort();
			for(var i:int=0; i<subMeshCount; ++i){
				subMeshList.push(readSubMesh(data));
			}
			trace(data.bytesAvailable);
		}
		
		private function readSubMesh(data:ByteArray):SubMesh
		{
			var textureName:String = data.readUTFBytes(data.readUnsignedByte());
			var vertexCount:int = data.readUnsignedShort();
			var data32PerVertex:int = data.readUnsignedByte();
			var vertexData:ByteArray = new ByteArray();
			data.readBytes(vertexData, 0, vertexCount * data32PerVertex << 2);
			var indexCount:int = data.readUnsignedInt();
			var indexData:ByteArray = new ByteArray();
			data.readBytes(indexData, 0, indexCount << 1);
			
			var vertexBuffer:GpuVertexBuffer = new GpuVertexBuffer(vertexCount, data32PerVertex);
			vertexBuffer.uploadBin(vertexData);
			var indexBuffer:GpuIndexBuffer = new GpuIndexBuffer(indexCount);
			indexBuffer.uploadBin(indexData);
			
			return new SubMesh(vertexFormatDict, vertexBuffer, indexBuffer);
		}
		
		public function draw(context3d:Context3D, contextStack:ProgramInfoStack):void
		{
			contextStack.pushConst(this);
			for each(var subMesh:SubMesh in subMeshList){
				contextStack.pushConst(subMesh);
				material.draw(context3d, subMesh, contextStack);
				contextStack.popConst();
			}
			contextStack.popConst();
		}
		
		public function loadConst(data:Vector.<Number>, name:String, fromRegister:int, toRegister:int):Boolean
		{
			if(name == "WorldMatrix"){
				GpuConstData.SetMatrix(data, fromRegister, worldTransform);
				return true;
			}
			return scene.loadConst(data, name, fromRegister, toRegister);
		}
	}
}