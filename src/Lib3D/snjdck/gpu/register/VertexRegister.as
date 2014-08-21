package snjdck.gpu.register
{
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuVertexBuffer;

	final public class VertexRegister
	{
		private var slotData:Vector.<GpuVertexBuffer>;
		private var slotOffset:Vector.<int>;
		private var slotFormat:Vector.<String>;
		
		public function VertexRegister(slotCount:int)
		{
			slotData = new Vector.<GpuVertexBuffer>(slotCount, true);
			slotOffset = new Vector.<int>(slotCount, true);
			slotFormat = new Vector.<String>(slotCount, true);
		}
		
		public function setVa(slotIndex:int, buffer:GpuVertexBuffer, offset:int=-1, format:String=null):void
		{
			slotData[slotIndex] = buffer;
			slotOffset[slotIndex] = offset;
			slotFormat[slotIndex] = format;
		}
		
		public function upload(context3d:GpuContext):void
		{
			for(var i:int=0, n:int=slotData.length; i<n; i++){
				if(slotData[i] != null){
					context3d.setVertexBufferAt(i, slotData[i], slotOffset[i], slotFormat[i]);
				}
			}
		}
		
		public function clear():void
		{
			for(var i:int=0, n:int=slotData.length; i<n; i++){
				slotData[i] = null;
			}
		}
		
		public function copyFrom(other:VertexRegister):void
		{
			for(var i:int=0, n:int=slotData.length; i<n; i++){
				slotData[i]		= other.slotData[i];
				slotOffset[i]	= other.slotOffset[i];
				slotFormat[i]	= other.slotFormat[i];
			}
		}
	}
}