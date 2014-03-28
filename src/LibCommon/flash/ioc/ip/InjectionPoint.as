package flash.ioc.ip
{
	import flash.ioc.IInjector;
	import flash.reflection.getType;
	import flash.reflection.getTypeInfo;
	import flash.reflection.getTypeName;
	import flash.reflection.typeinfo.MethodInfo;
	import flash.reflection.typeinfo.TypeInfo;
	import flash.reflection.typeinfo.VariableInfo;

	final public class InjectionPoint
	{
		static private const TAG_INJECT:String = "Inject";
		static private const injectionPointDict:Object = {};
		
		static private function Fetch(clsRef:Class):InjectionPoint
		{
			var clsName:String = getTypeName(clsRef);
			return injectionPointDict[clsName] ||= new InjectionPoint(clsRef);
		}
		
		static public function NewInstance(clsRef:Class, injector:IInjector):*
		{
			return Fetch(clsRef).newInstance(injector);
		}
		
		static public function InjectInto(target:Object, injector:IInjector):void
		{
			Fetch(getType(target)).injectInto(target, injector);
		}
		
		static public function GetTypesNeedInject(clsRef:Class):Array
		{
			return Fetch(clsRef).getTypesNeedInject();
		}
		
		private var injectionPointCtor:InjectionPointConstructor;
		private const injectionPointList:Array = [];
		
		public function InjectionPoint(clsRef:Class)
		{
			var clsInfo:TypeInfo = getTypeInfo(clsRef);
			
			injectionPointCtor = new InjectionPointConstructor(clsRef, clsInfo.ctor);
			
			for each(var varNode:VariableInfo in getFieldList(clsInfo)){
				injectionPointList.push(new InjectionPointProperty(
					varNode.name,
					varNode.getMetaTagValue(TAG_INJECT),
					varNode.type
				));
			}
			
			for each(var methodNode:MethodInfo in getMethodList(clsInfo)){
				injectionPointList.push(new InjectionPointMethod(
					methodNode.name,
					methodNode.parameters
				));
			}
		}
		
		private function newInstance(injector:IInjector):*
		{
			var obj:Object = injectionPointCtor.newInstance(injector);
			injectInto(obj, injector);
			return obj;
		}
		
		private function injectInto(target:Object, injector:IInjector):void
		{
			for each(var injectionPoint:IInjectionPoint in injectionPointList){
				injectionPoint.injectInto(target, injector);
			}
		}
		
		private function getTypesNeedInject():Array
		{
			var result:Array = [];
			injectionPointCtor.getTypesNeedInject(result);
			for each(var injectionPoint:IInjectionPoint in injectionPointList){
				injectionPoint.getTypesNeedInject(result);
			}
			return result;
		}
		
		static private function getFieldList(clsInfo:TypeInfo):Array
		{
			var fieldList:Array = [];
			for each(var varNode:VariableInfo in clsInfo.variables){
				if(varNode.hasMetaTag(TAG_INJECT) && varNode.canWrite()){
					fieldList.push(varNode);
				}
			}
			return fieldList;
		}
		
		static private function getMethodList(clsInfo:TypeInfo):Array
		{
			var methodList:Array = [];
			for each(var methodNode:MethodInfo in clsInfo.methods){
				if(methodNode.hasMetaTag(TAG_INJECT)){
					methodList.push(methodNode);
				}
			}
			return methodList.sort(_sortMethod);
		}
		
		static private function _sortMethod(left:MethodInfo, right:MethodInfo):int
		{
			return right.parameters.length - left.parameters.length;
		}
	}
}