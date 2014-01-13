package snjdck.agalc
{
	import flash.utils.Dictionary;
	
	internal class Operation
	{
		static private const NameDict:Dictionary = new Dictionary();
		static private const CodeDict:Dictionary = new Dictionary();
		
		static public function FetchByName(name:String):Operation
		{
			return NameDict[name];
		}
		
		public var name:String;
		public var code:uint;
		public var numRegister:uint;
		
		public function Operation(name:String, code:uint, numRegister:uint)
		{
			NameDict[name] = this;
			CodeDict[code] = this;
			
			this.name = name;
			this.code = code;
			this.numRegister = numRegister;
		}
	}
}