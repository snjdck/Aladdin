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
		static private const RESERVE_VC_COUNT:int = 4;
		
		private const quadGpuData:QuadGpuData = new QuadGpuData();
		private const trigGpuData:TrigGpuData = new TrigGpuData();
		
		private const constData:Vector.<Number> = new Vector.<Number>(1000, true);
		private var gpuData:IInstanceGpuData;
		
		public function InstanceRender(){}
		
		public function setVc(render:Render2D, worldMatrix:Matrix):void
		{
			render.copyProjectData(constData);
			if(worldMatrix != null)
				matrix33.toBuffer(worldMatrix, constData, 4);
		}
		
		public function drawQuad(context3d:GpuContext, instanceData:IInstanceData):void
		{
			gpuData = quadGpuData;
			drawImpl(context3d, instanceData);
		}
		
		public function drawTrig(context3d:GpuContext, instanceData:IInstanceData):void
		{
			gpuData = trigGpuData;
			drawImpl(context3d, instanceData);
		}
		
		private function drawImpl(context3d:GpuContext, instanceData:IInstanceData):void
		{
			var numRegisterPerInstance:int = instanceData.numRegisterPerInstance;
			var instanceCountPerBatch:int = (MAX_VC_COUNT - RESERVE_VC_COUNT) / numRegisterPerInstance;
			var totalInstanceCount:int = instanceData.numInstances;
			var batchCount:int = Math.ceil(totalInstanceCount / instanceCountPerBatch);
			var maxInstanceCount:int = Math.min(totalInstanceCount, instanceCountPerBatch);
			gpuData.initGpuData(context3d, maxInstanceCount);
			instanceData.initConstData(constData);
			for(var i:int=0; i<batchCount; ++i){
				var fromIndex:int = i * instanceCountPerBatch;
				var count:int = Math.min(instanceCountPerBatch, totalInstanceCount - fromIndex);
				instanceData.updateConstData(constData, fromIndex, count);
				context3d.setVc(0, constData, RESERVE_VC_COUNT + numRegisterPerInstance * count);
				gpuData.drawTriangles(context3d, count);
			}
		}
	}
}