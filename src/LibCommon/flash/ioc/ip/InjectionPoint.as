package flash.ioc.ip
{
	import flash.ioc.IInjectionPoint;
	import flash.ioc.IInjector;
	import flash.reflection.getTypeInfo;
	import flash.reflection.typeinfo.MethodInfo;
	import flash.reflection.typeinfo.TypeInfo;
	import flash.reflection.typeinfo.VariableInfo;
	import flash.utils.getQualifiedClassName;

	[ExcludeClass]
	final public class InjectionPoint implements IInjectionPoint
	{
		static private const TAG_INJECT:String = "Inject";
		static private const injectionPointDict:Object = {};
		
		static public function Fetch(clsRef:Class):InjectionPoint
		{
			var clsName:String = getQualifiedClassName(clsRef);
			if(null == injectionPointDict[clsName]){
				injectionPointDict[clsName] = new InjectionPoint(clsRef);
			}
			return injectionPointDict[clsName];
		}
		
		private const injectionPointList:Array = [];
		
		public function InjectionPoint(clsRef:Class)
		{
			var clsInfo:TypeInfo = getTypeInfo(clsRef);
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