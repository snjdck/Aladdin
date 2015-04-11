package flash.ioc
{
	public interface IInjector
	{
		function mapValue(keyCls:Class, value:Object, id:String=null, needInject:Boolean=true, realInjector:IInjector=null):void;
		function mapClass(keyCls:Class, valueCls:Class=null, id:String=null, realInjector:IInjector=null):void;
		function mapSingleton(keyCls:Class, valueCls:Class=null, id:String=null, realInjector:IInjector=null):void;
		function mapRule(keyCls:Class, rule:IInjectionType, id:String=null):void;
		
		function getMapping(key:String):IInjectionType;
		
		function unmap(keyCls:Class, id:String=null):void;
		
		function getInstance(keyClsOrName:Object, id:String=null):*;
		function injectInto(target:Object):void;
		
		function get parent():IInjector;
		function set parent(value:IInjector):void;
	}
}