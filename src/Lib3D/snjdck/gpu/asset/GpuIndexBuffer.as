package snjdck.gpu.asset
{
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
	}
}