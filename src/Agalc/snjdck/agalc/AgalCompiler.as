package snjdck.agalc
{
	import flash.display3D.Context3DProgramType;
	import flash.factory.newBuffer;
	import flash.utils.ByteArray;
	
	import array.has;
	import array.unique;
	
	import snjdck.agalc.arithmetic.TempRegFactory;
	
	import string.removeSpace;
	import string.trim;
	

	/**
	 * 一条指令中只能有一个常量寄存器访问
	 * 读取临时寄存器之前必须先写入
	 * v在顶点程序中为只写,在片段程序中为只读
	 * vc才能使用间接寻址,即使fc也不行!
	 * iid为顶点程序只读
	 */
	final public class AgalCompiler
	{
		static private const OpDict:Object = {
			"+":["add"], "-":["sub"], "*":["mul"], "/":["div"], "^":["pow"],
			"<":["slt"], ">":["slt",true],
			">=":["sge"], "<=":["sge",true],
			"==":["seq"], "!=":["sne"],
			"=":["mov"]
		};
		
		private var writer:AgalByteWriter;
		private var parser:AgalCodeWriter;
		private var isFragmentProgram:Boolean;
		
		private var arith:AgalArithmetic;
		
		private var usedVts:Array = [];
		private var unusedVts:Array = [];
		private var tempRegFactory:TempRegFactory;
		
		public var usedinputs:Array = [];
		public var shaderData:ByteArray;
		
		public function AgalCompiler(programType:String)
		{
			writer = new AgalByteWriter();
			parser = new AgalCodeWriter(writer);
			arith = new AgalArithmetic();
			
			shaderData = flash.factory.newBuffer();
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
		
		public function compile(tokenList:Array, version:int):void
		{
			reset();
			
			writer.writeHeader(isFragmentProgram?1:0, version);
			
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
			tempRegFactory = new TempRegFactory(unusedVts);
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
			tempRegFactory.reset();
			var codeList:Array = [];
			arith.parse(token).visit(codeList, tempRegFactory);
			for each(var code:Array in codeList){
				writeArithmetic.apply(null, code);
			}
		}
		
		private function writeArithmetic(symbol:String, dest:String, source1:String, source2:String=null):void
		{
			const info:Array = OpDict[symbol];
			
			if(null == info){
				writeTokenImp(symbol, dest, source1, source2);
				return;
			}
			
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
		
		private function writeTokenImp(opName:String, dest:String, source1:String, source2:String=null):void
		{
//			trace("---------",arguments.join(" "));
			
			var op:Operation = Operation.FetchByName(opName);
			writer.writeOP(op.code);
			if(op.flags & Operation.OP_NO_DEST){
				parser.writeDestination(null);
			}else{
				parser.writeDestination(dest);
			}
			parser.writeSource(source1);
			
			if(op.flags & Operation.OP_SPECIAL_TEX){
				parser.writeSampler(source2);
			}else{
				parser.writeSource(source2);
			}
		}
	}
}