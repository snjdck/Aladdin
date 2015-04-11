package snjdck.gpu.asset
{
	import flash.display.BitmapData;
	import flash.utils.IDataInput;
	

	final public class GpuAssetFactory
	{
		static public function CreateGpuVertexBuffer(data:Vector.<Number>, data32PerVertex:int):GpuVertexBuffer
		{
			var result:GpuVertexBuffer = new GpuVertexBuffer(data.length/data32PerVertex, data32PerVertex);
			result.upload(data);
			return result;
		}
		
		static public function CreateGpuIndexBuffer(data:Vector.<uint>, numIndices:int=-1):GpuIndexBuffer
		{
			var result:GpuIndexBuffer = new GpuIndexBuffer(numIndices > 0 ? numIndices : data.length);
			result.upload(data);
			return result;
		}
		
		static public function CreateGpuTexture(width:int, height:int, optimizeForRenderTarget:Boolean=false):IGpuTexture
		{
			if(optimizeForRenderTarget){
				return new GpuRenderTarget(width, height);
			}
			return new GpuTexture(width, height);
		}
		
		static public function CreateGpuTexture2(source:BitmapData):IGpuTexture
		{
			var result:GpuTexture = new GpuTexture(source.width, source.height);
			result.upload(source);
			return result;
		}
		
		static public function CreateGpuProgram(vertexProgram:Array, fragmentProgram:Array):GpuProgram
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
		
		static public function CreateQuadBuffer(quadCount:int):GpuIndexBuffer
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