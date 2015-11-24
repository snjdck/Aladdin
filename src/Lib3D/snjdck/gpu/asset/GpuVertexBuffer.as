package snjdck.gpu.asset
{
	final public class GpuVertexBuffer extends GpuAsset
	{
		private const uploadParams:Array = [];
		
		public function GpuVertexBuffer(numVertices:int, data32PerVertex:int, isDynamic:Boolean=false)
		{
			super("createVertexBuffer", [numVertices, data32PerVertex]);
			if(isDynamic && canUseBufferUsage){
				initParams.push("dynamicDraw");
			}
			uploadParams[1] = 0;
		}
		
		override public function dispose():void
		{
			super.dispose();
			uploadParams[0] = null;
		}
		
		public function upload(data:Vector.<Number>, numVertices:int=-1):void
		{
			uploadParams[0] = data;
			uploadParams[2] = (numVertices >= 0 ? numVertices : initParams[0]);
			uploadImp("uploadFromVector", uploadParams);
		}
	}
}