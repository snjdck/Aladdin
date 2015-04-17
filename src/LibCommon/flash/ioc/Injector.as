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
		private const dict:Object = {};
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
		
		public function mapValue(keyCls:Class, value:Object, id:String=null, needInject:Boolean=true, realInjector:IInjector=null):void
		{
			if(value != null){
				assert(value is keyCls, "type don't match!");
			}
			var rule:IInjectionType = new InjectionTypeValue(value, needInject, realInjector || this);
			mapRule(keyCls, rule, id);
		}
		
		public function mapClass(keyCls:Class, valueCls:Class=null, id:String=null, realInjector:IInjector=null):void
		{
			var rule:IInjectionType = new InjectionTypeClass(realInjector || this, valueCls || keyCls);
			mapRule(keyCls, rule, id);
		}
		
		public function mapSingleton(keyCls:Class, valueCls:Class=null, id:String=null, realInjector:IInjector=null):void
		{
			var rule:IInjectionType = new InjectionTypeSingleton(realInjector || this, valueCls || keyCls);
			mapRule(keyCls, rule, id);
		}
		
		public function mapRule(keyCls:Class, rule:IInjectionType, id:String=null):void
		{
			dict[getKey(keyCls, id)] = rule;
		}
		
		public function unmap(keyCls:Class, id:String=null):void
		{
			deleteKey(dict, getKey(keyCls, id));
		}
		
		public function getMapping(key:String):IInjectionType
		{
			return dict[key];
		}
		
		private function getInjectionType(key:String):IInjectionType
		{
			var injectionType:IInjectionType;
			var injector:IInjector = this;
			do{
				injectionType = injector.getMapping(key);
				injector = injector.parent;
			}while(!injectionType && injector);
			return injectionType;
		}
		
		public function getInstance(keyClsOrName:Object, id:String=null):*
		{
			var injectionType:IInjectionType = getInjectionType(getKey(keyClsOrName, id));
			if(injectionType){
				return injectionType.getValue(this, null);
			}
			if(!Boolean(id)){
				return null;
			}
			injectionType = getInjectionType(getKey(keyClsOrName));
			return injectionType && injectionType.getValue(this, id);
		}
		
		public function injectInto(target:Object):void
		{
			var ip:IInjectionPoint = InjectionPoint.Fetch(getType(target));
			ip.injectInto(target, this);
		}
	}
}