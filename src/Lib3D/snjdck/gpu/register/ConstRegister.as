package snjdck.gpu.register
{
	import flash.geom.Matrix3D;
	
	import array.copy;
	
	import snjdck.gpu.asset.GpuContext;

	final public class ConstRegister
	{
		private var slotUseInfo:Vector.<Boolean>;
		private var slotData:Vector.<Number>;
		
		public function ConstRegister(slotCount:int)
		{
			slotUseInfo = new Vector.<Boolean>(slotCount, true);
			slotData = new Vector.<Number>(slotCount * 4, true);
		}
		
		public function setByVector(firstRegister:int, data:Vector.<Number>, numRegisters:int=-1):void
		{
			if(-1 == numRegisters){
				numRegisters = Math.ceil(data.length / 4);
			}
			setUseInfo(firstRegister, numRegisters);
			array.copy(data, slotData, numRegisters * 4, 0, firstRegister * 4);
		}
		
		public function setByMatrix(firstRegister:int, matrix:Matrix3D):void
		{
			setUseInfo(firstRegister, 4);
			matrix.copyRawDataTo(slotData, firstRegister * 4, true);
		}
		
		public function setByBone(firstRegister:int, matrix:Matrix3D):void
		{
			setUseInfo(firstRegister, 3);
			
			var index:int = firstRegister * 4;
			var rawData:Vector.<Number> = matrix.rawData;
			
			slotData[index] = rawData[0];
			slotData[index+1] = rawData[4];
			slotData[index+2] = rawData[8];
			slotData[index+3] = rawData[12];
			slotData[index+4] = rawData[1];
			slotData[index+5] = rawData[5];
			slotData[index+6] = rawData[9];
			slotData[index+7] = rawData[13];
			slotData[index+8] = rawData[2];
			slotData[index+9] = rawData[6];
			slotData[index+10] = rawData[10];
			slotData[index+11] = rawData[14];
		}
		
		public function upload(context3d:GpuContext, programType:String):void
		{
			var firstRegister:int;
			var numRegisters:int;
			var flag:Boolean;
			
			for(var i:int=0, n:int=slotUseInfo.length; i<n; i++){
				var test:Boolean = slotUseInfo[i];
				if(flag){
					if(test){
						++numRegisters;
					}
					if(!test || i+1==n){
						context3d.setProgramConstantsFromVector(programType, firstRegister,
							array.copy(slotData, sharedFloatBuffer, numRegisters*4, firstRegister*4),
							numRegisters
						);
						flag = false;
					}
				}else if(test){
					firstRegister = i;
					numRegisters = 1;
					flag = true;
				}
			}
		}
		
		public function clear():void
		{
			for(var i:int=0, n:int=slotUseInfo.length; i<n; i++){
				slotUseInfo[i] = false;
			}
		}
		
		public function copyFrom(other:ConstRegister):void
		{
			array.copy(other.slotUseInfo, slotUseInfo, slotUseInfo.length);
			array.copy(other.slotData, slotData, slotData.length);
		}
		
		private function setUseInfo(firstRegister:int, numRegisters:int):void
		{
			for(var i:int=0; i<numRegisters; i++){
				var index:int = firstRegister + i;
				slotUseInfo[index] = true;
			}
		}
		
		static private const sharedFloatBuffer:Vector.<Number> = new Vector.<Number>();
	}
}