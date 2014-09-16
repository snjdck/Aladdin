package snjdck.gpu.register
{
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.IGpuTexture;

	final internal class FragmentRegister
	{
		private var slotCount:int;
		
		private var slotUseInfo:Vector.<Boolean>;
		private var slotData:Vector.<IGpuTexture>;
		
		public function FragmentRegister(slotCount:int)
		{
			this.slotCount = slotCount;
			slotUseInfo = new Vector.<Boolean>(slotCount, true);
			slotData = new Vector.<IGpuTexture>(slotCount, true);
		}
		
		public function setFs(slotIndex:int, texture:IGpuTexture):void
		{
			slotUseInfo[slotIndex] = true;
			slotData[slotIndex] = texture;
		}
		
		public function upload(context3d:GpuContext):void
		{
			for(var i:int=0; i<slotCount; i++){
				if(slotUseInfo[i]){
					context3d.setTextureAt(i, slotData[i]);
				}
			}
		}
		
		public function merge(other:FragmentRegister):void
		{
			for(var i:int=0; i<slotCount; i++){
				if(other.slotUseInfo[i]){
					slotUseInfo[i] = true;
					slotData[i] = other.slotData[i];
				}
			}
		}
		
		public function clear():void
		{
			for(var i:int=0; i<slotCount; i++){
				slotUseInfo[i] = false;
				slotData[i] = null;
			}
		}
		
		public function copyFrom(other:FragmentRegister):void
		{
			for(var i:int=0; i<slotCount; i++){
				slotUseInfo[i]	= other.slotUseInfo[i];
				slotData[i]		= other.slotData[i];
			}
		}
	}
}