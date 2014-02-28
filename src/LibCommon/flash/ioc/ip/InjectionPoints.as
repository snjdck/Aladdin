package flash.ioc.ip
{
	import array.push;
	
	import flash.reflection.getTypeInfo;
	
	import flash.ioc.IInjector;
	
	import flash.reflection.typeinfo.MethodInfo;
	import flash.reflection.typeinfo.TypeInfo;
	import flash.reflection.typeinfo.VariableInfo;

	[ExcludeClass]
	final public class InjectionPoints implements IInjectionPoint
	{
		private var injectionPointCtor:InjectionPointConstructor;
		private const injectionPointList:Array = [];
		private var hasSort:Boolean;
		
		public function InjectionPoints(clsRef:Class)
		{
			var clsInfo:TypeInfo = getTypeInfo(clsRef);
			
			injectionPointCtor = new InjectionPointConstructor(
				clsInfo.name,
				clsInfo.getMetaTagValue(TAG_INJECT),
				clsInfo.ctor
			);
			
			for each(var varNode:VariableInfo in clsInfo.variables){
				if(varNode.hasMetaTag(TAG_INJECT) && varNode.canWrite()){
					addInjectionPointProperty(varNode);
				}
			}
			
			for each(var methodNode:MethodInfo in clsInfo.methods){
				if(methodNode.hasMetaTag(TAG_INJECT)){
					addInjectionPointMethod(methodNode);
				}
			}
		}
		
		private function addInjectionPointProperty(varNode:VariableInfo):void
		{
			addInjectionPoint(
				new InjectionPointProperty(
					varNode.name,
					varNode.getMetaTagValue(TAG_INJECT),
					varNode.type
				)
			);
		}
		
		private function addInjectionPointMethod(methodNode:MethodInfo):void
		{
			addInjectionPoint(
				new InjectionPointMethod(
					methodNode.name,
					methodNode.getMetaTagValue(TAG_INJECT),
					methodNode.parameters
				)
			);
		}
		
		private function addInjectionPoint(injectionPoint:InjectionPoint):void
		{
			injectionPointList.push(injectionPoint);
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
			if(!hasSort){
				injectionPointList.sortOn("priority", Array.NUMERIC);
				hasSort = true;
			}
			
			for each(var injectionPoint:IInjectionPoint in injectionPointList){
				injectionPoint.injectInto(target, injector);
			}
		}
		
		public function get priority():int
		{
			return 0;
		}
		
		public function getTypesNeedToBeInjected(result:Array):void
		{
			injectionPointCtor.getTypesNeedToBeInjected(result);
			for each(var injectionPoint:IInjectionPoint in injectionPointList){
				injectionPoint.getTypesNeedToBeInjected(result);
			}
		}
		
		static private const TAG_INJECT:String = "Inject";
	}
}