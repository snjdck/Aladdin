package snjdck.agalc
{
	import flash.utils.Dictionary;
	
	internal class Operation
	{
		Init();
		static private function Init():void
		{
			new Operation("mov", 0x00, 2);	//		=
			new Operation("add", 0x01, 3);	//		+
			new Operation("sub", 0x02, 3);	//		-
			new Operation("mul", 0x03, 3);	//		*
			new Operation("div", 0x04, 3);	//		/
			new Operation("rcp", 0x05, 2);	//		1 / n
			new Operation("min", 0x06, 3);
			new Operation("max", 0x07, 3);
			new Operation("frc", 0x08, 2);	//		source1 - floor(source1)
			new Operation("sqt", 0x09, 2);	//		sqrt(source1)
			new Operation("rsq", 0x0a, 2);	//		1 / sqrt(source1)
			new Operation("pow", 0x0b, 3);	//		^
			new Operation("log", 0x0c, 2);	//		log2(source1)
			new Operation("exp", 0x0d, 2);	//		2 ^ n
			new Operation("nrm", 0x0e, 2);
			new Operation("sin", 0x0f, 2);
			new Operation("cos", 0x10, 2);
			new Operation("crs", 0x11, 3);
			new Operation("dp3", 0x12, 3);
			new Operation("dp4", 0x13, 3);
			new Operation("abs", 0x14, 2);
			new Operation("neg", 0x15, 2);	//		-n
			new Operation("sat", 0x16, 2);	//		max(min(source1,1),0)
			new Operation("m33", 0x17, 3, OP_SPECIAL_MATRIX);
			new Operation("m44", 0x18, 3, OP_SPECIAL_MATRIX);
			new Operation("m34", 0x19, 3, OP_SPECIAL_MATRIX);
			
			//version 2
			new Operation("ddx", 0x1a, 2, OP_FRAG_ONLY);
			new Operation("ddy", 0x1b, 2, OP_FRAG_ONLY);
			new Operation("ife", 0x1c, 2, OP_NO_DEST);	//		Jump if source1 is equal to source2
			new Operation("ine", 0x1d, 2, OP_NO_DEST);	//		Jump if source1 is not equal to source2
			new Operation("ifg", 0x1e, 2, OP_NO_DEST);	//		Jump if source1 is greater or equal than source2
			new Operation("ifl", 0x1f, 2, OP_NO_DEST);	//		Jump if source1 is less than source2
			new Operation("els", 0x20, 0, OP_NO_DEST);	//		else
			new Operation("eif", 0x21, 0, OP_NO_DEST);	//		End an if or else block
			
			/*
			new Operation("rep", 0x24, 1);	//		repeat vt0.x
			new Operation("erp", 0x25, 0);	//		end repeat
			//*/
			new Operation("ted", 0x26, 3, OP_FRAG_ONLY | OP_SPECIAL_TEX);
			new Operation("kil", 0x27, 1, OP_FRAG_ONLY | OP_NO_DEST);
			new Operation("tex", 0x28, 3, OP_FRAG_ONLY | OP_SPECIAL_TEX);
			new Operation("sge", 0x29, 3);	//		>=
			new Operation("slt", 0x2a, 3);	//		<
			new Operation("sgn", 0x2b, 2);	//		(sign) destination = (source1 < 0) ? (-1) : (source1 > 0 ? 1 : 0) - 不支持
			new Operation("seq", 0x2c, 3);	//		==
			new Operation("sne", 0x2d, 3);	//		!=
		}
		
		static public const OP_SPECIAL_TEX		:uint = 0x8;
		static public const OP_SPECIAL_MATRIX	:uint = 0x10;
		static public const OP_FRAG_ONLY		:uint = 0x20;
		static public const OP_VERT_ONLY		:uint = 0x40;
		static public const OP_NO_DEST			:uint = 0x80;
		
		static private const NameDict:Dictionary = new Dictionary();
		static private const CodeDict:Dictionary = new Dictionary();
		
		static public function FetchByName(name:String):Operation
		{
			return NameDict[name];
		}
		
		public var name:String;
		public var code:uint;
		public var numRegister:uint;
		public var flags:uint;
		
		public function Operation(name:String, code:uint, numRegister:uint, flags:uint=0)
		{
			NameDict[name] = this;
			CodeDict[code] = this;
			
			this.name = name;
			this.code = code;
			this.numRegister = numRegister;
			this.flags = flags;
		}
	}
}