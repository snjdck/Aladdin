package snjdck.agalc
{
	import flash.display3D.Context3DProgramType;
	import flash.utils.ByteArray;
	
	import array.has;
	import array.unique;
	
	import stdlib.factory.newBuffer;
	
	import lambda.apply;
	
	import snjdck.agalc.arithmetic.TempRegFactory;
	
	import string.execRegExp;
	import string.removeSpace;
	import string.trim;
	

	/**
	 * 一条指令中只能有一个常量寄存器访问
	 * 读取临时寄存器之前必须先写入
	 * v在顶点程序中为只写,在片段程序中为只读
	 * vc才能使用间接寻址,即使fc也不行!
	 */
	final public class AgalCompiler
	{
		new Register("va", RegisterType.Attribute);
		new Register("fs", RegisterType.Sampler);
		new Register("vc", RegisterType.Constant);
		new Register("fc", RegisterType.Constant);
		new Register("vt", RegisterType.Temporary);
		new Register("ft", RegisterType.Temporary);
		new Register("v",  RegisterType.Varying);
		new Register("op", RegisterType.Output);
		new Register("oc", RegisterType.Output);
		new Register("od", RegisterType.DepthOutput);
		
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
		new Operation("m33", 0x17, 3);
		new Operation("m44", 0x18, 3);
		new Operation("m34", 0x19, 3);
		
		//version 2
		new Operation("ddx", 0x1a, 2);
		new Operation("ddy", 0x1b, 2);
		new Operation("ife", 0x1c, 2);	//		Jump if source1 is equal to source2
		new Operation("ine", 0x1d, 2);	//		Jump if source1 is not equal to source2
		new Operation("ifg", 0x1e, 2);	//		Jump if source1 is greater or equal than source2
		new Operation("ifl", 0x1f, 2);	//		Jump if source1 is less than source2
		new Operation("els", 0x20, 0);	//		else
		new Operation("eif", 0x21, 0);	//		End an if or else block
		
		/*
		new Operation("rep", 0x24, 1);	//		repeat vt0.x
		new Operation("erp", 0x25, 0);	//		end repeat
		//*/
		new Operation("ted", 0x26, 3);
		new Operation("kil", 0x27, 1);
		new Operation("tex", 0x28, 3);
		new Operation("sge", 0x29, 3);	//		>=
		new Operation("slt", 0x2a, 3);	//		<
		new Operation("sgn", 0x2b, 2);	//		(sign) destination = (source1 < 0) ? (-1) : (source1 > 0 ? 1 : 0) - 不支持
		new Operation("seq", 0x2c, 3);	//		==
		new Operation("sne", 0x2d, 3);	//		!=
		
		static private const OpDict:Object = {
			"+":["add"], "-":["sub"], "*":["mul"], "/":["div"], "^":["pow"],
			"<":["slt"], ">":["slt",true],
			">=":["sge"], "<=":["sge",true],
			"==":["seq"], "!=":["sne"]
		};
		
		static private const SlotPattern:RegExp = /([a-z]{1,2})(\d{0,3})(?:\.([xyzw]{1,4}))?/;
		
		private var writer:AgalByteWriter;
		private var parser:AgalCodeWriter;
		private var isFragmentProgram:Boolean;
		
		private var arith:AgalArithmetic;
		
		private var usedVts:Array = [];
		private var unusedVts:Array = [];
		
		public var usedinputs:Array = [];
		public var shaderData:ByteArray;
		
		public function AgalCompiler(programType:String)
		{
			writer = new AgalByteWriter();
			parser = new AgalCodeWriter(writer);
			arith = new AgalArithmetic();
			
			shaderData = stdlib.factory.newBuffer();
			isFragmentProgram = (Context3DProgramType.FRAGMENT == programType);
			writer.setRawData(shaderData);
		}
		
		private function reset():void
		{
			usedVts.length = 0;
			unusedVts.length = 0;
			usedinputs.length = 0;
			shaderData.clear();
		}
		
		public function compile(tokenList:Array):void
		{
			reset();
			
			writer.writeHeader(isFragmentProgram?1:0, 1);
			
			tokenList = tokenList.map(__array_removeSpace);
			usedVts = array.unique(usedVts);
			usedinputs = array.unique(usedinputs);
			
			prepareData();
			
			tokenList.forEach(__array_writeToken);
		}
		
		private function prepareData():void
		{
			for(var i:int=0; i<8; i++){
				var reg:String = (isFragmentProgram ? "f" : "v") + "t" + i;
				if(!array.has(usedVts, reg)){
					unusedVts.push(reg);
				}
			}
			usedinputs = usedinputs.map(__array_mapToIndex);
		}
		
		private function __array_mapToIndex(register:String, index:int, array:Array):int
		{
			return int(register.slice(2));
		}
		
		private function __array_removeSpace(token:String, index:int, array:Array):String
		{
			array.append(usedVts, token.match(/[vf]t\d/g));
			array.append(usedinputs, token.match(/(?:va|fs)\d/g));
			return removeSpace(trim(token));
		}
		
		private function __array_writeToken(token:String, index:int, array:Array):void
		{
			return writeToken(token);
		}
		
		private function writeToken(token:String):void
		{
			var test:Array = execRegExp(/(?:(.+\w)([+\-*\/]?)=)?(.+)/, token);
			const dest:String = test[1];
			const extraOp:String = test[2];
			const rest:String = test[3];
			
			test = execRegExp(/(\w{3}):([^,]+)(?:,(.+))?/, rest);//函数
			if(test){
				writeTokenImp(test[1], dest, test[2], test[3]);
				return;
			}
			
			if(execRegExp(/[+\-*\/^<>=]/, rest)){//运算符
				if(extraOp){
					var tempReg:String = unusedVts[0];
					writeArithmetic3(tempReg, rest);
					writeArithmetic(extraOp, dest, dest, tempReg);
				}else{
					writeArithmetic3(dest, rest);
				}
				return;
			}
			
			if(execRegExp(SlotPattern, rest)){//mov
				if(extraOp){
					writeArithmetic(extraOp, dest, dest, rest);
				}else{
					writeTokenImp("mov", dest, rest);
				}
				return;
			}
			
			throw new Error("format error!" + token);
		}
		
		private function writeArithmetic3(dest:String, input:String):void
		{
			var codeList:Array = [];
			arith.parse(input).visit(codeList, new TempRegFactory(unusedVts));
			codeList[codeList.length-1][1] = dest;
			for each(var code:Array in codeList){
				lambda.apply(writeArithmetic, code);
			}
		}
		
		private function writeArithmetic(symbol:String, dest:String, source1:String, source2:String):void
		{
			const info:Array = OpDict[symbol];
			const op:String = info[0];
			
			if(info[1]){
				writeTokenImp(op, dest, source2, source1);
			}else{
				switch(source1+symbol){
					case "0-":
						writeTokenImp("neg", dest, source2);
						break;
					case "1/":
						writeTokenImp("rcp", dest, source2);
						break;
					case "2^":
						writeTokenImp("exp", dest, source2);
						break;
					default:
						writeTokenImp(op, dest, source1, source2);
				}
			}
		}
		
		private function writeTokenImp(op:String, dest:String, source1:String, source2:String=null):void
		{
//			trace("---------",arguments.join(" "));
			writer.writeOP(Operation.FetchByName(op).code);
			parser.writeDestination(dest);
			parser.writeSource(source1);
			
			if("tex" == op){
				parser.writeSampler(source2);
			}else{
				parser.writeSource(source2);
			}
		}
	}
}