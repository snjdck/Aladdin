package snjdck.gpu.register
{
	import flash.display3D.Context3D;
	
	import snjdck.gpu.asset.IGpuTexture;

	final public class FragmentRegister
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
		
		public function upload(context3d:Context3D):void
		{
			for(var i:int=0; i<slotCount; i++){
				if(slotUseInfo[i]){
					var texture:IGpuTexture = slotData[i];
					context3d.setTextureAt(i, texture.getRawGpuAsset(context3d));
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