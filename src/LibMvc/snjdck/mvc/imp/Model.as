package snjdck.mvc.imp
{
	import flash.utils.Dictionary;
	
	import dict.deleteKey;
	import dict.hasKey;
	
	import snjdck.mvc.Module;
	import snjdck.mvc.core.IModel;
	
	import snjdck.injector.IInjector;

	public class Model implements IModel
	{
		[Inject]
		public var module:Module;
		
		[Inject]
		public var injector:IInjector;
		
		private const proxyRefs:Object = new Dictionary();
		
		public function Model()
		{
		}
		
		public function regProxy(proxyCls:Class):void
		{
			if(!hasProxy(proxyCls)){
				var proxy:Proxy = injector.getInstance(proxyCls);
				if(null == proxy){//if proxyCls has not mapped yet, mapSingleton!
					injector.mapSingleton(proxyCls);
					arguments.callee(proxyCls);
				}else{
					proxyRefs[proxyCls] = proxy;
					proxy.regToModule(module);
				}
			}
		}
		
		public function delProxy(proxyCls:Class):void
		{
			if(hasProxy(proxyCls)){
				var proxy:Proxy = deleteKey(proxyRefs, proxyCls);
				proxy.delFromModule(module);
			}
		}
		
		public function hasProxy(proxyCls:Class):Boolean
		{
			return hasKey(proxyRefs, proxyCls);
		}
	}
}