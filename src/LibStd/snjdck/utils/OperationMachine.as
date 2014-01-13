package snjdck.utils
{
	import flash.utils.Dictionary;
	
	import lambda.apply;

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
			for(var pattern:* in patternDict){
				var paramList:Array = pattern.exec(input);
				if(paramList){
					return apply(this[patternDict[pattern]], paramList.slice(1));
				}
			}
		}
	}
}