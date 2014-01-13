package snjdck.mvc.helper
{
	import array.del;
	import array.has;
	import array.push;
	import array.pushIfNotHas;
	
	import snjdck.injector.IInjector;
	
	import stdlib.reflection.getTypeName;
	
	import string.replace;

	public class ServiceInitializer
	{
		private var serviceDefList:Array;
		
		public function ServiceInitializer()
		{
			this.serviceDefList = [];
		}
		
		public function regService(serviceRegInfo:ServiceRegInfo):void
		{
			serviceDefList.push(serviceRegInfo);
		}
		
		public function initialize(appInjector:IInjector):void
		{
			serviceDefList = resortList(serviceDefList);
			for each(var serviceRegInfo:ServiceRegInfo in serviceDefList){
				serviceRegInfo.regService(appInjector);
			}
		}
		
		private function resortList(list:Array):Array
		{
			var serviceInFinding:Array = [];
			var result:Array = [];
			for each(var serviceRegInfo:ServiceRegInfo in list){
				insertServiceRegInfo(serviceRegInfo, list, result, serviceInFinding);
			}
			return result;
		}
		
		private function insertServiceRegInfo(serviceRegInfo:ServiceRegInfo, list:Array, result:Array, serviceInFinding:Array):void
		{
			var isServiceInFinding:Boolean = has(serviceInFinding, serviceRegInfo);
			push(serviceInFinding, serviceRegInfo);
			if(isServiceInFinding){
				throwRecursionError(serviceInFinding);
			}
			for each(var serviceClsName:String in serviceRegInfo.getTypesNeedToBeInjected()){
				var dependent:ServiceRegInfo = findServiceRegInfo(list, serviceClsName);
				if(null == dependent){
					continue;
				}
				insertServiceRegInfo(dependent, list, result, serviceInFinding);
			}
			del(serviceInFinding, serviceRegInfo);
			
			pushIfNotHas(result, serviceRegInfo);
		}
		
		private function findServiceRegInfo(list:Array, serviceClsName:String):ServiceRegInfo
		{
			for each(var serviceRegInfo:ServiceRegInfo in list){
				if(getTypeName(serviceRegInfo.serviceInterface) == serviceClsName){
					return serviceRegInfo;
				}
			}
			return null;
		}
		
		private function throwRecursionError(serviceInFinding:Array):void
		{
			var printInfo:Array = [];
			for each(var serviceRegInfo:ServiceRegInfo in serviceInFinding){
				printInfo.push(getTypeName(serviceRegInfo.serviceClass));
			}
			throw new Error(string.replace("service is recursively used:[${0}]", [printInfo.join(" -> ")]));
		}
	}
}