package flash.ioc
{
	import flash.ioc.ip.InjectionPoint;
	import flash.ioc.it.InjectionTypeClass;
	import flash.ioc.it.InjectionTypeSingleton;
	import flash.ioc.it.InjectionTypeValue;
	import flash.reflection.getType;
	import flash.support.TypeCast;
	
	import dict.deleteKey;

	public class Injector implements IInjector
	{
		private const ruleDict:Object = {};
		private var _parent:IInjector;
		
		public function Injector()
		{
		}
		
		public function get parent():IInjector
		{
			return _parent;
		}

		public function set parent(value:IInjector):void
		{
			_parent = value;
		}

		private function getKey(keyClsOrName:Object, id:String=null):String
		{
			var key:String = TypeCast.CastClsToStr(keyClsOrName);
			return id ? (key + "@" + id) : key;
		}
		
		private function getMetaKey(keyClsOrName:Object):String
		{
			var key:String = TypeCast.CastClsToStr(keyClsOrName);
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
		
		public function mapRule(keyCls:Class, rule:IInjectionType, id:String=null):void
		{
			ruleDict[getKey(keyCls, id)] = rule;
		}
		
		public function mapMetaRule(keyCls:Class, rule:IInjectionType):void
		{
			ruleDict[getMetaKey(keyCls)] = rule;
		}
		
		public function unmap(keyCls:Class, id:String=null):void
		{
			deleteKey(ruleDict, getKey(keyCls, id));
		}
		
		public function getMapping(key:String):IInjectionType
		{
			return ruleDict[key];
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
				injector = injector.parent as Injector;
			}while(injector);
			return null;
		}
		
		public function getInstance(keyClsOrName:Object, id:String=null):*
		{
			var rule:IInjectionType = getRule(getKey(keyClsOrName, id)) || getRule(getMetaKey(keyClsOrName));
			return rule && rule.getValue(this, id);
		}
		
		public function injectInto(target:Object):void
		{
			var ip:IInjectionPoint = InjectionPoint.Fetch(getType(target));
			ip.injectInto(target, this);
		}
	}
}