package snjdck.g3d.asset.impl
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.utils.IDataInput;
	
	import snjdck.g3d.asset.IGpuContext;
	import snjdck.g3d.asset.IGpuIndexBuffer;
	import snjdck.g3d.asset.IGpuProgram;
	import snjdck.g3d.asset.IGpuTexture;
	import snjdck.g3d.asset.IGpuVertexBuffer;

	final public class GpuAssetFactory
	{
		static public function CreateGpuContext(context3d:Context3D):IGpuContext
		{
			return new GpuContext(context3d);
		}
		
		static public function CreateGpuVertexBuffer(data:Vector.<Number>, data32PerVertex:int):IGpuVertexBuffer
		{
			var result:GpuVertexBuffer = new GpuVertexBuffer(data.length/data32PerVertex, data32PerVertex);
			result.upload(data);
			return result;
		}
		
		static public function CreateGpuVertexBuffer2(numVertices:int, data32PerVertex:int):IGpuVertexBuffer
		{
			return new GpuVertexBuffer(numVertices, data32PerVertex);
		}
		
		static public function CreateGpuIndexBuffer(data:Vector.<uint>, numIndices:int=-1):IGpuIndexBuffer
		{
			var result:GpuIndexBuffer = new GpuIndexBuffer(numIndices > 0 ? numIndices : data.length);
			result.upload(data);
			return result;
		}
		
		static public function CreateGpuTexture(width:int, height:int, optimizeForRenderTarget:Boolean=false):IGpuTexture
		{
			if(optimizeForRenderTarget){
				return new GpuRenterTarget(width, height);
			}
			return new GpuTexture(width, height);
		}
		
		static public function CreateGpuTexture2(source:BitmapData):IGpuTexture
		{
			var result:GpuTexture = new GpuTexture(source.width, source.height);
			result.upload(source);
			return result;
		}
		
		static public function CreateGpuProgram(vertexProgram:Array, fragmentProgram:Array):IGpuProgram
		{
			var result:GpuProgram = new GpuProgram();
			result.upload(vertexProgram, fragmentProgram);
			return result;
		}
		
		static public function ReadVertexBufferFromByteArray(buffer:IDataInput, count:int, output:Vector.<Number>):void
		{
			for(var i:int=0; i<count; i++){
				output[i] = buffer.readFloat();
			}
		}
		
		static public function ReadIndexBufferFromByteArray(buffer:IDataInput, count:int, output:Vector.<uint>):void
		{
			for(var i:int=0; i<count; i++){
				output[i] = buffer.readUnsignedShort();
			}
		}
		
		static private const quadIndexBuffer:Vector.<uint> = new <uint>[];
		
		static public function CreateQuadBuffer(quadCount:int):IGpuIndexBuffer
		{
			for(var i:int=quadIndexBuffer.length/6; i<quadCount; i++){
				var vertexIndex:int = i * 4;//每个quad包含四个顶点
				quadIndexBuffer.push(
					vertexIndex, vertexIndex+1, vertexIndex+2,
					vertexIndex, vertexIndex+2, vertexIndex+3
				);
			}
			return CreateGpuIndexBuffer(quadIndexBuffer, quadCount*6);
		}
		
		static public const DefaultGpuTexture:IGpuTexture = CreateGpuTexture2(new BitmapData(1, 1, true, 0xFFFFFFFF));
	}
}