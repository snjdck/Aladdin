package snjdck.agalc
{
	import flash.utils.Dictionary;

	internal class Register
	{
		Init();
		static private function Init():void
		{
			new Register("va", TYPE_Attribute);
			new Register("fs", TYPE_Sampler);
			new Register("vc", TYPE_Constant);
			new Register("fc", TYPE_Constant);
			new Register("vt", TYPE_Temporary);
			new Register("ft", TYPE_Temporary);
			new Register("v",  TYPE_Varying);
			new Register("op", TYPE_Output);
			new Register("oc", TYPE_Output);
			new Register("od", TYPE_DepthOutput);
			new Register("iid",TYPE_InstanceID);
		}
		
		static public const TYPE_Attribute		:uint = 0x0;	//va
		static public const TYPE_Constant		:uint = 0x1;	//vc, fc
		static public const TYPE_Temporary		:uint = 0x2;	//vt, ft
		static public const TYPE_Output			:uint = 0x3;	//op, oc
		static public const TYPE_Varying		:uint = 0x4;	//v
		static public const TYPE_Sampler		:uint = 0x5;	//fs
		static public const TYPE_DepthOutput	:uint = 0x6;	//fd
		static public const TYPE_InstanceID		:uint = 0x7;	//iid
		
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