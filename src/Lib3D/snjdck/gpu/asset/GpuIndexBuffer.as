package snjdck.gpu.asset
{
	import flash.utils.ByteArray;

	final public class GpuIndexBuffer extends GpuAsset
	{
		private const uploadParams:Array = [];
		
		public function GpuIndexBuffer(numIndices:int)
		{
			super("createIndexBuffer", arguments);
			uploadParams[1] = 0;
		}
		
		override public function dispose():void
		{
			super.dispose();
			uploadParams[0] = null;
		}
		
		public function upload(data:Vector.<uint>, count:int=-1):void
		{
			uploadParams[0] = data;
			uploadParams[2] = (count >= 0 ? count : initParams[0]);
			uploadImp("uploadFromVector", uploadParams);
		}
		
		public function uploadBin(data:ByteArray):void
		{
			uploadParams[0] = data;
			uploadParams[1] = 0;
			uploadParams[2] = 0;
			uploadParams[3] = initParams[0];
			uploadImp("uploadFromByteArray", uploadParams);
		}
	}
}