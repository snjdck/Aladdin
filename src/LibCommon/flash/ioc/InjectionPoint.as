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
			if(null == injectionPointDict[clsName])
				injectionPointDict[clsName] = new InjectionPoint(target);
			return injectionPointDict[clsName];
		}
		
		private const injectionPointList:Vector.<IInjectionPoint> = new Vector.<IInjectionPoint>();
		
		public function InjectionPoint(target:Object)
		{
			var clsInfo:TypeInfo = getTypeInfo(target);
			for each(var methodNode:MethodInfo in clsInfo.methods)
				if(methodNode.hasMetaTag(TAG_INJECT))
					injectionPointList.insertAt(
						methodNode.parameters.length > 0 ? 0 : injectionPointList.length,
						new InjectionPointMethod(methodNode.name, methodNode.parameters)
					);
			for each(var varNode:VariableInfo in clsInfo.variables)
				if(varNode.hasMetaTag(TAG_INJECT) && varNode.canWrite())
					injectionPointList.unshift(
						new InjectionPointProperty(varNode.name, varNode.getMetaTagValue(TAG_INJECT), varNode.type)
					);
		}
		
		public function injectInto(target:Object, injector:IInjector):void
		{
			for each(var injectionPoint:IInjectionPoint in injectionPointList)
				injectionPoint.injectInto(target, injector);
		}
	}
}