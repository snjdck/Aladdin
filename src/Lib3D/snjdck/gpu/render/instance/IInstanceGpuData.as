package snjdck.gpu.render.instance
{
	import snjdck.gpu.asset.GpuContext;

	internal interface IInstanceGpuData
	{
		function initGpuData(context3d:GpuContext, maxInstanceCount:int):void;
		function drawTriangles(context3d:GpuContext, instanceCount:int):void;
	}
}