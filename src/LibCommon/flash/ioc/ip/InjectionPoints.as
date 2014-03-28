package flash.ioc.ip
{
	import flash.ioc.IInjector;
	import flash.reflection.getTypeInfo;
	import flash.reflection.typeinfo.MethodInfo;
	import flash.reflection.typeinfo.TypeInfo;
	import flash.reflection.typeinfo.VariableInfo;

	[ExcludeClass]
	final public class InjectionPoints implements IInjectionPoint
	{
		static private const TAG_INJECT:String = "Inject";
		
		private var injectionPointCtor:InjectionPointConstructor;
		private const injectionPointList:Array = [];
		
		public function InjectionPoints(clsRef:Class)
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
		
		public function newInstance(injector:IInjector):*
		{
			var obj:Object = injectionPointCtor.newInstance(injector);
			injectInto(obj, injector);
			return obj;
		}
		
		/**
		 * 1.注入属性
		 * 2.注入有参数的方法
		 * 3.注入无参数的方法
		 */
		public function injectInto(target:Object, injector:IInjector):void
		{
			for each(var injectionPoint:IInjectionPoint in injectionPointList){
				injectionPoint.injectInto(target, injector);
			}
		}
		
		public function getTypesNeedInject(result:Array):void
		{
			injectionPointCtor.getTypesNeedInject(result);
			for each(var injectionPoint:IInjectionPoint in injectionPointList){
				injectionPoint.getTypesNeedInject(result);
			}
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