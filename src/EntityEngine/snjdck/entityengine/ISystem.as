package snjdck.entityengine
{
	public interface ISystem
	{
		function onInit():void;
		function onUpdate(timeElapsed:int):void;
	}
}