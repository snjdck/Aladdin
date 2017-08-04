package test
{
	import flash.display3D.Context3D;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import snjdck.g3d.core.Object3D;
	import snjdck.gpu.asset.GpuIndexBuffer;
	import snjdck.gpu.asset.GpuVertexBuffer;
	import snjdck.gpu.support.GpuConstData;

	public class ModelLoader extends Object3D implements IProgramConstContext
	{
		private var subMeshList:Array = [];
		private var vertexFormatDict:Object = {}
		public var program:ProgramReader;
		
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
		
		public function draw(context3d:Context3D):void
		{
			for each(var subMesh:SubMesh in subMeshList){
				program.upload(context3d, subMesh, this);
				subMesh.draw(context3d);
			}
		}
		
		public function loadConst(data:Vector.<Number>, name:String, fromRegister:int, toRegister:int):void
		{
			switch(name){
				case "WorldMatrix":
					GpuConstData.SetMatrix(data, fromRegister, worldTransform);
			}
			scene.loadConst(data, name, fromRegister, toRegister);
		}
	}
}
import flash.display3D.Context3D;
import flash.display3D.textures.TextureBase;

import snjdck.gpu.asset.AssetMgr;
import snjdck.gpu.asset.GpuAssetFactory;
import snjdck.gpu.asset.GpuIndexBuffer;
import snjdck.gpu.asset.GpuVertexBuffer;
import snjdck.gpu.asset.IGpuTexture;

import test.IProgramInputContext;
import test.ProgramReader;
import test.VertexBuffer3DInfo;

class SubMesh implements IProgramInputContext
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
	
	public function loadTexture(name:String):IGpuTexture
	{
		return AssetMgr.Instance.getTexture(name);
	}
	
	public function loadVertexBuffer(name:String, format:String):VertexBuffer3DInfo
	{
		var info:VertexBuffer3DInfo = vertexFormatDict[name];
		info.assertFormatEqual(format);
		return info;
	}
	
	public function draw(context3d:Context3D):void
	{
		context3d.drawTriangles(indexBuffer.getRawGpuAsset(context3d));
	}
}