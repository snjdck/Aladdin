package snjdck.tesla.kernel.services
{
	import flash.signals.ISignal;

	public interface ISceneService
	{
		function gotoScene(sceneName:String):void;
		function backToLastScene():void;
		
		function get currentSceneName():String;
		
		function get enterSceneSignal():ISignal;
		function get leaveSceneSignal():ISignal;
		
		function showViewInScenes(sceneNames:Array, callback:Function):void;
		function hideViewInScenes(sceneNames:Array, callback:Function):void;
	}
}