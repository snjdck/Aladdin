package snjdck.tesla.kernel.services.impl
{
	import flash.signals.ISignal;
	import flash.signals.Signal;
	import snjdck.tesla.kernel.services.ISceneService;
	import snjdck.tesla.kernel.services.support.Service;

	public class SceneService extends Service implements ISceneService
	{
		private const sceneStack:Vector.<String> = new Vector.<String>();
		
		private const _enterSceneSignal:Signal = new Signal(String);
		private const _leaveSceneSignal:Signal = new Signal(String);
		
		public function SceneService()
		{
		}
		
		public function get currentSceneName():String
		{
			if(sceneStack.length <= 0){
				return null;
			}
			return sceneStack[sceneStack.length-1];
		}
		
		public function backToLastScene():void
		{
			if(sceneStack.length >= 2){
				gotoScene(sceneStack[sceneStack.length-2]);
			}
		}
		
		public function gotoScene(sceneName:String):void
		{
			if(currentSceneName == sceneName){
				return;
			}
			
			if(sceneStack.length > 0){
				_leaveSceneSignal.notify(currentSceneName);
			}
			
			const sceneIndex:int = sceneStack.indexOf(sceneName);
			
			if(sceneIndex < 0){
				sceneStack.push(sceneName);
			}else{
				sceneStack.length = sceneIndex + 1;
			}
			
			_enterSceneSignal.notify(currentSceneName);
		}
		
		public function get enterSceneSignal():ISignal
		{
			return _enterSceneSignal;
		}
		
		public function get leaveSceneSignal():ISignal
		{
			return _leaveSceneSignal;
		}
		
		public function showViewInScenes(sceneNames:Array, callback:Function):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function hideViewInScenes(sceneNames:Array, callback:Function):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function toString():String
		{
			return sceneStack.join(" -> ");
		}
	}
}