package snjdck.entityengine.helper
{
	import snjdck.entityengine.EntityEngine;
	import snjdck.entityengine.Node;
	
	import flash.ioc.IInjector;
	import flash.ioc.it.IInjectionType;
	
	import flash.reflection.getType;
	
	[ExcludeClass]
	public class InjectionTypeNodeGroup implements IInjectionType
	{
		public function getValue(injector:IInjector, id:String):Object
		{
			var entityEngine:EntityEngine = injector.getInstance(EntityEngine);
			return entityEngine.getNodeList(getType(id));
		}
	}
}