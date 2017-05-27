package snjdck.ai
{
	import string.execRegExp;

	public class OperationMachine
	{
		private var patternDict:Object;
		private var _context:Object;
		
		public function OperationMachine()
		{
			patternDict = {};
		}
		
		public function get context():*
		{
			return _context;
		}
		
		public function set context(value:Object):void
		{
			_context = value;
		}
		
		public function regPattern(methodName:String, pattern:RegExp):void
		{
			patternDict[methodName] = pattern;
		}
		
		public function exec(input:String):*
		{
			for(var methodName:String in patternDict){
				var pattern:RegExp = patternDict[methodName];
				var paramList:Array = execRegExp(pattern, input);
				if (null == paramList) continue;
				var method:Function = context[methodName];
				return method.apply(null, paramList.slice(1));
			}
		}
	}
}