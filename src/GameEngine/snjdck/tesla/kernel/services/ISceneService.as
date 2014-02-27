package snjdck.tesla.kernel.services
{
	import snjdck.mvc.core.IService;
	import flash.signals.ISignal;

	public interface ISceneService extends IService
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