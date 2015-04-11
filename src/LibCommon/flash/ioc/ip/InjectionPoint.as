package flash.ioc.ip
{
	import flash.ioc.IInjectionPoint;
	import flash.ioc.IInjector;
	import flash.reflection.getTypeInfo;
	import flash.reflection.getTypeName;
	import flash.reflection.typeinfo.MethodInfo;
	import flash.reflection.typeinfo.TypeInfo;
	import flash.reflection.typeinfo.VariableInfo;

	[ExcludeClass]
	final public class InjectionPoint implements IInjectionPoint
	{
		static private const TAG_INJECT:String = "Inject";
		static private const injectionPointDict:Object = {};
		
		static public function Fetch(clsRef:Class):InjectionPoint
		{
			var clsName:String = getTypeName(clsRef);
			if(null == injectionPointDict[clsName]){
				injectionPointDict[clsName] = new InjectionPoint(clsRef);
			}
			return injectionPointDict[clsName];
		}
		
		private const injectionPointList:Array = [];
		
		public function InjectionPoint(clsRef:Class)
		{
			var clsInfo:TypeInfo = getTypeInfo(clsRef);
			
			for each(var varNode:VariableInfo in clsInfo.variables){
				if(varNode.hasMetaTag(TAG_INJECT) && varNode.canWrite()){
					addPropertyPoint(varNode);
				}
			}
			
			for each(var methodNode:MethodInfo in clsInfo.methods){
				if(methodNode.hasMetaTag(TAG_INJECT) && methodNode.parameters.length > 0){
					addMethodPoint(methodNode);
				}
			}
			
			for each(var methodNode:MethodInfo in clsInfo.methods){
				if(methodNode.hasMetaTag(TAG_INJECT) && methodNode.parameters.length == 0){
					addMethodPoint(methodNode);
				}
			}
		}
		
		private function addPropertyPoint(varNode:VariableInfo):void
		{
			injectionPointList.push(new InjectionPointProperty(
				varNode.name,
				varNode.getMetaTagValue(TAG_INJECT),
				varNode.type
			));
		}
		
		private function addMethodPoint(methodNode:MethodInfo):void
		{
			injectionPointList.push(new InjectionPointMethod(
				methodNode.name,
				methodNode.parameters
			));
		}
		
		public function injectInto(target:Object, injector:IInjector):void
		{
			for each(var injectionPoint:IInjectionPoint in injectionPointList){
				injectionPoint.injectInto(target, injector);
			}
		}
	}
}