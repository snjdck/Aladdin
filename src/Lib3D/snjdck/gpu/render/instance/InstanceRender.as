package snjdck.gpu.render.instance
{
	import flash.geom.Matrix;
	
	import matrix33.toBuffer;
	
	import snjdck.g2d.render.Render2D;
	import snjdck.gpu.asset.GpuContext;
	
	final public class InstanceRender
	{
		static public const Instance:InstanceRender = new InstanceRender();
		static public var MAX_VC_COUNT:int = 128;
		
		private const quadGpuData:QuadGpuData = new QuadGpuData();
		private const trigGpuData:TrigGpuData = new TrigGpuData();
		
		public const constData:Vector.<Number> = new Vector.<Number>(1000, true);
		private var gpuData:IInstanceGpuData;
		
		public function InstanceRender(){}
		
		public function setVc(render:Render2D, worldMatrix:Matrix):void
		{
			render.copyProjectData(constData);
			if(worldMatrix != null)
				matrix33.toBuffer(worldMatrix, constData, 4);
		}
		
		public function drawQuad(context3d:GpuContext, instanceData:IInstanceData, instanceCount:int):void
		{
			gpuData = quadGpuData;
			drawImpl(context3d, instanceData, instanceCount);
		}
		
		public function drawTrig(context3d:GpuContext, instanceData:IInstanceData, instanceCount:int):void
		{
			gpuData = trigGpuData;
			drawImpl(context3d, instanceData, instanceCount);
		}
		
		private function drawImpl(context3d:GpuContext, instanceData:IInstanceData, totalInstanceCount:int):void
		{
			var numRegisterPerInstance:int = instanceData.numRegisterPerInstance;
			var numRegisterReserved:int = instanceData.numRegisterReserved;
			var maxInstanceCountPerBatch:int = (MAX_VC_COUNT - numRegisterReserved) / numRegisterPerInstance;
			var batchCount:int = Math.ceil(totalInstanceCount / maxInstanceCountPerBatch);
			var maxInstanceCountWillUse:int = Math.min(totalInstanceCount, maxInstanceCountPerBatch);
			gpuData.initGpuData(context3d, maxInstanceCountWillUse);
			instanceData.initConstData(constData);
			for(var i:int=0; i<batchCount; ++i){
				var fromIndex:int = i * maxInstanceCountPerBatch;
				var count:int = Math.min(maxInstanceCountPerBatch, totalInstanceCount - fromIndex);
				instanceData.updateConstData(constData, fromIndex, count);
				context3d.setVc(0, constData, numRegisterReserved + numRegisterPerInstance * count);
				gpuData.drawTriangles(context3d, count);
			}
		}
	}
}