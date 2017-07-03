package flash.ioc
{
	import flash.reflection.getTypeInfo;
	import flash.reflection.typeinfo.MethodInfo;
	import flash.reflection.typeinfo.TypeInfo;
	import flash.reflection.typeinfo.VariableInfo;
	import flash.utils.getQualifiedClassName;

	internal class InjectionPoint
	{
		static private const TAG_INJECT:String = "Inject";
		static private const InjectionPointDict:Object = {};
		
		static public function Fetch(target:Object):Vector.<IInjectionPoint>
		{
			var className:String = getQualifiedClassName(target);
			if(InjectionPointDict[className] == null)
				InjectionPointDict[className] = CreateInjectionPointList(target);
			return InjectionPointDict[className];
		}
		
		static private function CreateInjectionPointList(target:Object):Vector.<IInjectionPoint>
		{
			var injectionPointList:Vector.<IInjectionPoint> = new Vector.<IInjectionPoint>();
			var classInfo:TypeInfo = getTypeInfo(target);
			var varNode:VariableInfo, methodNode:MethodInfo;
			for each(varNode in classInfo.variables)  if(varNode.hasMetaTag(TAG_INJECT) && varNode.canWrite())
				injectionPointList.push(new InjectionPointProperty(varNode.name, varNode.type, varNode.getMetaTagValue(TAG_INJECT)));
			for each(methodNode in classInfo.methods) if(methodNode.hasMetaTag(TAG_INJECT) && methodNode.parameters.length != 0)
				injectionPointList.push(new InjectionPointMethod(methodNode.name, methodNode.parameters));
			for each(methodNode in classInfo.methods) if(methodNode.hasMetaTag(TAG_INJECT) && methodNode.parameters.length == 0)
				injectionPointList.push(new InjectionPointMethod0(methodNode.name));
			return injectionPointList;
		}
	}
}