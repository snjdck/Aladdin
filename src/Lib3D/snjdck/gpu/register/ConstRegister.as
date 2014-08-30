package snjdck.gpu.register
{
	import flash.display3D.Context3D;
	import flash.geom.Matrix3D;
	
	import array.copy;

	final public class ConstRegister
	{
		private var programType:String;
		private var slotCount:int;
		
		private var slotUseInfo:Vector.<Boolean>;
		private var slotData:Vector.<Number>;
		
		private var beginIndex:int;
		private var endIndex:int;
		
		public function ConstRegister(slotCount:int, programType:String)
		{
			this.programType = programType;
			this.slotCount = slotCount;
			slotUseInfo = new Vector.<Boolean>(slotCount, true);
			slotData = new Vector.<Number>(slotCount * 4, true);
			clear();
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
		/*
		public function upload(context3d:Context3D):void
		{
			var firstRegister:int;
			var numRegisters:int;
			var flag:Boolean;
			
			for(var i:int=0; i<slotCount; i++){
				var test:Boolean = slotUseInfo[i];
				if(flag){
					if(test){
						++numRegisters;
					}
					if(!test || i+1==slotCount){
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
		//*/
		public function upload(context3d:Context3D):void
		{
			if(beginIndex >= endIndex){
				return;
			}
			var numRegisters:int = endIndex - beginIndex;
			var uploadData:Vector.<Number>;
			if(beginIndex > 0){
				uploadData = sharedFloatBuffer;
				array.copy(slotData, sharedFloatBuffer, numRegisters*4, beginIndex*4);
			}else{
				uploadData = slotData;
			}
			context3d.setProgramConstantsFromVector(programType, beginIndex, uploadData, numRegisters);
			trace(beginIndex, endIndex, numRegisters);
		}
		
		public function merge(other:ConstRegister):void
		{
			var otherSlotUseInfo:Vector.<Boolean> = other.slotUseInfo;
			var otherSlotData:Vector.<Number> = other.slotData;
			for(var i:int=other.beginIndex; i<other.endIndex; i++){
				if(!otherSlotUseInfo[i]){
					continue;
				}
				slotUseInfo[i] = true;
				var offset:int = 4 * i;
				for(var j:int=0; j<4; j++){
					slotData[offset] = otherSlotData[offset];
					++offset;
				}
			}
			if(other.beginIndex < beginIndex){
				beginIndex = other.beginIndex;
			}
			if(other.endIndex > endIndex){
				endIndex = other.endIndex;
			}
		}
		
		public function copyFrom(other:ConstRegister):void
		{
			var otherSlotUseInfo:Vector.<Boolean> = other.slotUseInfo;
			var otherSlotData:Vector.<Number> = other.slotData;
			var offset:int = 0;
			for(var i:int=0; i<slotCount; i++){
				slotUseInfo[i] = otherSlotUseInfo[i];
				for(var j:int=0; j<4; j++){
					slotData[offset] = otherSlotData[offset];
					++offset;
				}
			}
			beginIndex = other.beginIndex;
			endIndex = other.endIndex;
		}
		
		public function clear():void
		{
			for(var i:int=beginIndex; i<endIndex; i++){
				slotUseInfo[i] = false;
			}
			beginIndex = slotCount;
			endIndex = 0;
		}
		
		private function setUseInfo(firstRegister:int, numRegisters:int):void
		{
			var lastRegister:int = firstRegister + numRegisters;
			for(var i:int=firstRegister; i<lastRegister; i++){
				slotUseInfo[i] = true;
			}
			if(firstRegister < beginIndex){
				beginIndex = firstRegister;
			}
			if(lastRegister > endIndex){
				endIndex = lastRegister;
			}
		}
		
		static private const sharedFloatBuffer:Vector.<Number> = new Vector.<Number>();
	}
}