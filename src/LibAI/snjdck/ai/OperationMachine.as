package snjdck.ai
{
	import flash.utils.Dictionary;
	
	import lambda.apply;
	
	import string.execRegExp;

	public class OperationMachine
	{
		private var patternDict:Object;
		private var context:Object;
		
		public function OperationMachine(context:Object=null)
		{
			this.patternDict = new Dictionary();
			this.context = context;
		}
		
		public function getContext():*
		{
			return context;
		}
		
		public function setContext(value:Object):void
		{
			context = value;
		}
		
		public function regPattern(pattern:RegExp, methodName:String):void
		{
			patternDict[pattern] = methodName;
		}
		
		public function exec(input:String):*
		{
			for(var pattern:* in patternDict)
			{
				var paramList:Array = execRegExp(pattern, input);
				if (null == paramList) continue;
				var methodName:String = patternDict[pattern];
				var method:Function = context[methodName];
				return apply(method, paramList.slice(1));
			}
		}
	}
}