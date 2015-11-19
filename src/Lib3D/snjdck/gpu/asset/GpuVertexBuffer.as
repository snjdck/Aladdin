package snjdck.gpu.asset
{
	final public class GpuVertexBuffer extends GpuAsset
	{
		private var _useInstanceDraw:Boolean;
		private const uploadParams:Array = [];
		
		public function GpuVertexBuffer(numVertices:int, data32PerVertex:int, isDynamic:Boolean=false, numInstances:int=1)
		{
			_useInstanceDraw = numInstances > 1;
			var initName:String = _useInstanceDraw ? "createVertexBufferForInstances" : "createVertexBuffer";
			super(initName, [numVertices, data32PerVertex]);
			if(_useInstanceDraw){
				initParams.push(numInstances);
			}
			if(isDynamic && canUseBufferUsage){
				initParams.push("dynamicDraw");
			}
			uploadParams[1] = 0;
		}
		
		public function get useInstanceDraw():Boolean
		{
			return _useInstanceDraw;
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