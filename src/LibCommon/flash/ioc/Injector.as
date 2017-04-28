package flash.ioc
{
	import flash.ioc.ip.InjectionPoint;
	import flash.ioc.it.InjectionTypeClass;
	import flash.ioc.it.InjectionTypeSingleton;
	import flash.ioc.it.InjectionTypeValue;
	import flash.reflection.getType;
	import flash.utils.getQualifiedClassName;
	
	public class Injector implements IInjector
	{
		public var parent:Injector;
		
		private const ruleDict:Object = {};
		
		public function Injector(){}

		private function calcKey(type:Class, id:String=null):String
		{
			var key:String = getQualifiedClassName(type);
			return id ? (key + "@" + id) : key;
		}
		
		private function calcMetaKey(type:Class):String
		{
			var key:String = getQualifiedClassName(type);
			return key + "@";
		}
		
		public function mapValue(keyCls:Class, value:Object, id:String=null, needInject:Boolean=true, realInjector:IInjector=null):void
		{
			if(value != null){
				assert(value is keyCls, "type don't match!");
			}
			if(null == realInjector){
				realInjector = this;
			}
			var rule:IInjectionType = new InjectionTypeValue(value, needInject, realInjector);
			mapRule(keyCls, rule, id);
		}
		
		public function mapClass(keyCls:Class, valueCls:Class=null, id:String=null, realInjector:IInjector=null):void
		{
			if(null == realInjector){
				realInjector = this;
			}
			var rule:IInjectionType = new InjectionTypeClass(realInjector, valueCls || keyCls);
			mapRule(keyCls, rule, id);
		}
		
		public function mapSingleton(keyCls:Class, valueCls:Class=null, id:String=null, realInjector:IInjector=null):void
		{
			if(null == realInjector){
				realInjector = this;
			}
			var rule:IInjectionType = new InjectionTypeSingleton(realInjector, valueCls || keyCls);
			mapRule(keyCls, rule, id);
		}
		
		public function mapRule(type:Class, rule:IInjectionType, id:String=null):void
		{
			ruleDict[calcKey(type, id)] = rule;
		}
		
		public function mapMetaRule(type:Class, rule:IInjectionType):void
		{
			ruleDict[calcMetaKey(type)] = rule;
		}
		
		public function unmap(type:Class, id:String=null):void
		{
			delete ruleDict[calcKey(type, id)];
		}
		
		private function getRule(key:String, inherit:Boolean=true):IInjectionType
		{
			if(!inherit){
				return ruleDict[key];
			}
			var rule:IInjectionType;
			var injector:Injector = this;
			do{
				rule = injector.getRule(key, false);
				if(rule) return rule;
				injector = injector.parent;
			}while(injector);
			return null;
		}
		
		public function getInstance(type:Class, id:String=null):*
		{
			var rule:IInjectionType = getRule(calcKey(type, id)) || getRule(calcMetaKey(type));
			return rule && rule.getValue(this, id);
		}
		
		public function injectInto(target:Object):void
		{
			var ip:IInjectionPoint = InjectionPoint.Fetch(getType(target));
			ip.injectInto(target, this);
		}
	}
}