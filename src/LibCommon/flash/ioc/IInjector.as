package flash.ioc
{
	import flash.ioc.it.IInjectionType;

	public interface IInjector
	{
		function mapValue(keyCls:Class, value:Object, id:String=null, needInject:Boolean=true):void;
		function mapClass(keyCls:Class, valueCls:Class=null, id:String=null):void;
		function mapSingleton(keyCls:Class, valueCls:Class=null, id:String=null):void;
		function mapRule(keyCls:Class, rule:IInjectionType):void;
		
		function getMapping(key:String):IInjectionType;
		
		function unmap(keyCls:Class, id:String=null):void;
		
		function getInstance(keyClsOrName:Object, id:String=null):*;
		function getInstances(argTypes:Array):Array;
		function newInstance(clsRef:Class):*;
		function injectInto(target:Object):void;
		
		function getTypesNeedInject(keyClsOrName:Object):Array;
		
		function get parent():IInjector;
		function set parent(value:IInjector):void;
	}
}