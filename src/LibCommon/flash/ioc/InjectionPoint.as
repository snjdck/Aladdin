package flash.ioc
{
	import flash.reflection.getTypeInfo;
	import flash.reflection.typeinfo.MethodInfo;
	import flash.reflection.typeinfo.TypeInfo;
	import flash.reflection.typeinfo.VariableInfo;
	import flash.utils.getQualifiedClassName;

	internal class InjectionPoint implements IInjectionPoint
	{
		static private const TAG_INJECT:String = "Inject";
		static private const injectionPointDict:Object = {};
		
		static public function Fetch(target:Object):InjectionPoint
		{
			var clsName:String = getQualifiedClassName(target);
			if(null == injectionPointDict[clsName]){
				injectionPointDict[clsName] = new InjectionPoint(target);
			}
			return injectionPointDict[clsName];
		}
		
		private const injectionPointList:Array = [];
		
		public function InjectionPoint(target:Object)
		{
			var clsInfo:TypeInfo = getTypeInfo(target);
			for each(var methodNode:MethodInfo in clsInfo.methods){
				if(methodNode.hasMetaTag(TAG_INJECT)){
					addMethodPoint(methodNode, methodNode.parameters.length > 0);
				}
			}
			for each(var varNode:VariableInfo in clsInfo.variables){
				if(varNode.hasMetaTag(TAG_INJECT) && varNode.canWrite()){
					addPropertyPoint(varNode);
				}
			}
		}
		
		private function addPropertyPoint(varNode:VariableInfo):void
		{
			injectionPointList.unshift(new InjectionPointProperty(
				varNode.name,
				varNode.getMetaTagValue(TAG_INJECT),
				varNode.type
			));
		}
		
		private function addMethodPoint(methodNode:MethodInfo, toHeadFlag:Boolean):void
		{
			var injectionPoint:IInjectionPoint = new InjectionPointMethod(
				methodNode.name,
				methodNode.parameters
			);
			if(toHeadFlag){
				injectionPointList.unshift(injectionPoint);
			}else{
				injectionPointList.push(injectionPoint);
			}
		}
		
		public function injectInto(target:Object, injector:IInjector):void
		{
			for each(var injectionPoint:IInjectionPoint in injectionPointList){
				injectionPoint.injectInto(target, injector);
			}
		}
	}
}