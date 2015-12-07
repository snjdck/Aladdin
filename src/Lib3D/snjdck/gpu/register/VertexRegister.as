package snjdck.gpu.register
{
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuProgram;
	import snjdck.gpu.asset.GpuVertexBuffer;

	final public class VertexRegister
	{
		private const slotCount:int = 4;
		
		private var slotUseInfo:Vector.<Boolean>;
		private var slotData:Vector.<GpuVertexBuffer>;
		private var slotOffset:Vector.<int>;
		private var slotFormat:Vector.<String>;
		
		public function VertexRegister()
		{
			slotUseInfo = new Vector.<Boolean>(slotCount, true);
			slotData = new Vector.<GpuVertexBuffer>(slotCount, true);
			slotOffset = new Vector.<int>(slotCount, true);
			slotFormat = new Vector.<String>(slotCount, true);
		}
		
		public function setVa(slotIndex:int, buffer:GpuVertexBuffer, offset:int=-1, format:String=null):void
		{
			slotUseInfo[slotIndex] = true;
			slotData[slotIndex] = buffer;
			slotOffset[slotIndex] = offset;
			slotFormat[slotIndex] = format;
		}
		
		public function upload(context3d:GpuContext):void
		{
			for(var i:int=0; i<slotCount; ++i){
				if(slotUseInfo[i] && context3d.isVaSlotInUse(i)){
					context3d.setVertexBufferAt(i, slotData[i], slotOffset[i], slotFormat[i]);
				}
			}
		}
		
		public function onProgramChanged(program:GpuProgram):void
		{
			for(var i:int=0; i<slotCount; ++i){
				if(slotUseInfo[i] && !program.isVaSlotInUse(i)){
					slotUseInfo[i] = false;
					slotData[i] = null;
				}
			}
		}
		/*
		public function merge(other:VertexRegister):void
		{
			for(var i:int=0; i<slotCount; ++i){
				if(other.slotUseInfo[i]){
					slotUseInfo[i] = true;
					slotData[i] = other.slotData[i];
					slotOffset[i] = other.slotOffset[i];
					slotFormat[i] = other.slotFormat[i];
				}
			}
		}
		//*/
		public function clear():void
		{
			for(var i:int=0; i<slotCount; ++i){
				slotUseInfo[i] = false;
				slotData[i] = null;
			}
		}
		
		public function copyFrom(other:VertexRegister):void
		{
			for(var i:int=0; i<slotCount; ++i){
				slotUseInfo[i]	= other.slotUseInfo[i];
				slotData[i]		= other.slotData[i];
				slotOffset[i]	= other.slotOffset[i];
				slotFormat[i]	= other.slotFormat[i];
			}
		}
	}
}