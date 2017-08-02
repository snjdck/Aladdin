package test
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Program3D;
	import flash.utils.ByteArray;
	
	import snjdck.gpu.asset.GpuProgram;

	public class ProgramReader
	{
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
		/*
		public function createGpuProgram(context3d:Context3D):void
		{
			program3d = context3d.createProgram();
			program3d.upload(vertexData.code, fragmentData.code);
		}
		*/
		public function upload(context3d:Context3D, context:IProgramContext):void
		{
			context3d.setProgram(program3d.getRawGpuAsset(context3d));
			vertexData.upload(context3d, context);
			fragmentData.upload(context3d, context);
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