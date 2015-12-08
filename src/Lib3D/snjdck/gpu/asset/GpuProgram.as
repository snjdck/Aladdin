package snjdck.gpu.asset
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.utils.ByteArray;
	
	import snjdck.agalc.AgalCompiler;
	import snjdck.g3d.ns_g3d;
	
	use namespace ns_g3d;
	
	final public class GpuProgram extends GpuAsset
	{
		static private function UnsetInputs(useInfo:uint, method:Function):void
		{
			var slotIndex:int = 0;
			while(useInfo > 0){
				if(useInfo & 1){
					method(slotIndex, null);
				}
				useInfo >>>= 1;
				++slotIndex;
			}
		}
		
		static public var AgalVersion:int = 1;
		
		public var name:String;
		
		private var vsData:AgalCompiler;
		private var fsData:AgalCompiler;
		
		private var vaUseInfo:uint;
		private var fsUseInfo:uint;
		
		public function GpuProgram()
		{
			super("createProgram", arguments);
			vsData = new AgalCompiler(Context3DProgramType.VERTEX);
			fsData = new AgalCompiler(Context3DProgramType.FRAGMENT);
		}
		
		public function upload(vertexProgram:Array, fragmentProgram:Array):void
		{
			vsData.compile(vertexProgram, AgalVersion);
			fsData.compile(fragmentProgram, AgalVersion);
			
			vaUseInfo = fsUseInfo = 0;
			
			var regIndex:int;
			for each(regIndex in vsData.usedinputs){
				vaUseInfo |= (1 << regIndex);
			}
			for each(regIndex in fsData.usedinputs){
				fsUseInfo |= (1 << regIndex);
			}
			
			uploadBin(vsData.shaderData, fsData.shaderData);
		}
		
		public function uploadBin(vertexProgram:ByteArray, fragmentProgram:ByteArray):void
		{
			uploadImp("upload", [vertexProgram, fragmentProgram]);
		}
		
		public function isVaSlotInUse(slotIndex:int):Boolean
		{
			return (vaUseInfo & (1 << slotIndex)) != 0;
		}
		
		public function isFsSlotInUse(slotIndex:int):Boolean
		{
			return (fsUseInfo & (1 << slotIndex)) != 0;
		}
		
		public function unsetInputs(prevProgram:GpuProgram, context3d:Context3D):void
		{
			if(prevProgram != null){
				UnsetInputs(prevProgram.vaUseInfo & ~vaUseInfo, context3d.setVertexBufferAt);
				UnsetInputs(prevProgram.fsUseInfo & ~fsUseInfo, context3d.setTextureAt);
			}
		}
	}
}