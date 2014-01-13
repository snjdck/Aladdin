package snjdck.agalc
{
	import flash.utils.Dictionary;

	internal class Register
	{
		static public function FetchByName(name:String):Register
		{
			return NameDict[name];
		}
		
		static private const NameDict:Dictionary = new Dictionary();
		
		private var name:String;
		public var type:uint;
		
		public function Register(name:String, type:uint)
		{
			NameDict[name] = this;
			
			this.name = name;
			this.type = type;
		}
	}
}