package flash.ioc
{
	import dict.deleteKey;
	
	import flash.ioc.ip.InjectionPoints;
	import flash.ioc.it.IInjectionType;
	import flash.ioc.it.InjectionTypeClass;
	import flash.ioc.it.InjectionTypeSingleton;
	import flash.ioc.it.InjectionTypeValue;
	
	import flash.reflection.getType;
	import flash.reflection.getTypeName;
	import stdlib.typecast.castClsRefOrClsNameToString;

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
			var key:String = castClsRefOrClsNameToString(keyClsOrName);
			return id ? (key + "@" + id) : key;
		}
		
		public function mapValue(keyCls:Class, value:Object, id:String=null, needInject:Boolean=true):void
		{
			dict[getKey(keyCls, id)] = new InjectionTypeValue(value, needInject);
		}
		
		public function mapClass(keyCls:Class, valueCls:Class=null, id:String=null):void
		{
			dict[getKey(keyCls, id)] = new InjectionTypeClass(valueCls || keyCls);
		}
		
		public function mapSingleton(keyCls:Class, valueCls:Class=null, id:String=null):void
		{
			dict[getKey(keyCls, id)] = new InjectionTypeSingleton(valueCls || keyCls);
		}
		
		public function mapRule(keyCls:Class, rule:IInjectionType):void
		{
			dict[getKey(keyCls)] = rule;
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
			}else if(id){
				injectionType = getInjectionType(getKey(keyClsOrName));
			}
			
			return injectionType && injectionType.getValue(this, id);
		}
		
		public function newInstance(clsRef:Class):*
		{
			return getInjectionPoint(clsRef).newInstance(this);
		}
		
		public function injectInto(target:Object):void
		{
			getInjectionPoint(getType(target)).injectInto(target, this);
		}
		
		public function getTypesNeedToBeInjected(keyClsOrName:Object):Array
		{
			var result:Array = [];
			getInjectionPoint(getType(keyClsOrName)).getTypesNeedToBeInjected(result);
			return result;
		}
		
		private function getInjectionPoint(clsRef:Class):InjectionPoints
		{
			var clsName:String = getTypeName(clsRef);
			return clsInfoDic[clsName] ||= new InjectionPoints(clsRef);
		}
		
		static private const clsInfoDic:Object = {};
	}
}