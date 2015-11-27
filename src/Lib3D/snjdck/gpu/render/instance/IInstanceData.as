package snjdck.gpu.render.instance
{
	public interface IInstanceData
	{
		function get numRegisterPerInstance():int;
		function get numInstances():int;
		function initConstData(constData:Vector.<Number>):void;
		function updateConstData(constData:Vector.<Number>, instanceOffset:int, instanceCount:int):void;
	}
}