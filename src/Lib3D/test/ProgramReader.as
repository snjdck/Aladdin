package test
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Program3D;
	import flash.utils.ByteArray;
	
	import snjdck.gpu.asset.GpuProgram;

	public class ProgramReader
	{
		static private var prevVaCount:int;
		static private var prevFsCount:int;
		
		private var data:ByteArray;
		
		public const vertexData:ProgramData = new ProgramData(Context3DProgramType.VERTEX);
		public const fragmentData:ProgramData = new ProgramData(Context3DProgramType.FRAGMENT);
		
		private var program3d:GpuProgram = new GpuProgram();
		
		public function ProgramReader(data:ByteArray)
		{
			this.data = data;
			
			readProgram(vertexData);
			readProgram(fragmentData);
			program3d.uploadAGAL(this);
		}
		
		public function uploadConst(context3d:Context3D, constContext:IProgramConstContext):void
		{
			context3d.setProgram(program3d.getRawGpuAsset(context3d));
			uploadXC(vertexData, constContext);
			uploadXC(fragmentData, constContext);
			vertexData.uploadConst(context3d);
			fragmentData.uploadConst(context3d);
		}
		
		private function uploadXC(target:ProgramData, context:IProgramConstContext):void
		{
			for(var key:String in target._const){
				var info:Array = target._const[key];
				context.loadConst(target.constVector, key, info[0], info[1]);
			}
		}
		
		public function uploadVA(context3d:Context3D, context:IProgramVertexBufferContext):void
		{
			var i:int, n:int;
			for(i=0, n=vertexData._input.length; i<n; ++i){
				var vertexBuffer:VertexBuffer3DInfo = context.loadVertexBuffer.apply(null, vertexData._input[i]);
				vertexBuffer.setVertexBufferAt(context3d, i);
			}
			for(;i < prevVaCount; ++i){
				context3d.setVertexBufferAt(i, null);
			}
			prevVaCount = n;
		}
		
		public function uploadFS(context3d:Context3D, context:IProgramTextureContext):void
		{
			var i:int, n:int;
			for(i=0, n=fragmentData._input.length; i<n; ++i){
				context3d.setTextureAt(i, context.loadTexture(fragmentData._input[i][0]).getRawGpuAsset(context3d));
			}
			for(;i < prevFsCount; ++i){
				context3d.setTextureAt(i, null);
			}
			prevFsCount = n;
		}
		
		private function readProgram(info:ProgramData):void
		{
			info._input = readInput();
			info._const = readConst();
			readData(info);
			readCode(info);
			info.calcFirstRegister();
		}
		
		private function readInput():Array
		{
			var result:Array = [];
			var n:int = readByte();
			for(var i:int=0; i<n; ++i){
				result[i] = [readStr(), readStr()];
			}
			return result;
		}
		
		private function readConst():Object
		{
			var result:Object = {};
			var n:int = readByte();
			for(var i:int=0; i<n; ++i){
				result[readStr()] = [readByte(), readByte()];
			}
			return result;
		}
		
		private function readData(info:ProgramData):void
		{
			info.numRegisters = readByte();
			if(info.numRegisters > 0){
				data.readBytes(info.data, 0, info.numRegisters << 4);
			}
		}
		
		private function readCode(info:ProgramData):void
		{
			var n:uint = data.readUnsignedShort();
			if(n > 0){
				data.readBytes(info.code, 0, n);
			}
		}
		
		private function readByte():uint
		{
			return data.readUnsignedByte();
		}
		
		private function readStr():String
		{
			return data.readUTFBytes(data.readUnsignedByte());
		}
	}
}