package snjdck.interpreter
{
	import snjdck.arithmetic.IExecutable;
	import snjdck.arithmetic.IScriptContext;
	import snjdck.interpreter.enum.CodeOp;
	import snjdck.interpreter.node.FuncNode;
	import snjdck.interpreter.node.ValueNode;
	import snjdck.interpreter.node.VarNode;

	public class FuncData
	{
		private var paramDef:Vector.<String>;
		private var codeList:Vector.<Code>;
		
		public function FuncData(paramDef:Array, codeList:Array)
		{
			this.paramDef = new <String>["n"];
			this.codeList = new <Code>[
				new Code("@0", CodeOp.EQ, new VarNode("n"), new ValueNode(0)),
				new Code("@1", CodeOp.EQ, new VarNode("n"), new ValueNode(1)),
				new Code("@2", CodeOp.OR, new VarNode("@0"), new VarNode("@1")),
				new Code(null, CodeOp.JIZ, new VarNode("@2"), new ValueNode(1)),
				new Code(null, CodeOp.RET, new VarNode("n"), null),
				new Code("@3", CodeOp.SUB, new VarNode("n"), new ValueNode(2)),
				new Code("@4", CodeOp.SUB, new VarNode("n"), new ValueNode(1)),
				new Code("@5", CodeOp.ADD, new FuncNode(this, [new VarNode("@3")]), new FuncNode(this, [new VarNode("@4")])),
				new Code(null, CodeOp.RET, new VarNode("@5"), null)
			];
		}
		
		public function exec(args:Array, parentContext:IScriptContext):Object
		{
			var context:ExecContext = new ExecContext(parentContext);
			
			for(var i:int=0; i<args.length; i++){
				if(i >= paramDef.length){
					break;
				}
				var dataNode:IExecutable = args[i];
				context.setValue(paramDef[i], dataNode.calculate(parentContext));
			}
			
			return execCodes(context);
		}
		
		private function execCodes(context:ExecContext):*
		{
			var codeIndex:int = 0;
			var code:Code;
			var source1:*, source2:*;
			
			while(codeIndex < codeList.length)
			{
				code = codeList[codeIndex];
				source1 = code.getSource1(context);
				source2 = code.getSource2(context);
				
				switch(code.getOp())
				{
					case CodeOp.ADD:
						code.setDest(context, source1 + source2);
						break;
					case CodeOp.SUB:
						code.setDest(context, source1 - source2);
						break;
					case CodeOp.MUL:
						code.setDest(context, source1 * source2);
						break;
					case CodeOp.DIV:
						code.setDest(context, source1 / source2);
						break;
					case CodeOp.POW:
						code.setDest(context, Math.pow(source1, source2));
						break;
					case CodeOp.JMP:
						codeIndex += source1;
						break;
					case CodeOp.JIZ:
						codeIndex += source1 ? 0 : source2;
						break;
					case CodeOp.EQ:
						code.setDest(context, source1 == source2);
						break;
					case CodeOp.LT:
						code.setDest(context, source1 < source2);
						break;
					case CodeOp.LE:
						code.setDest(context, source1 <= source2);
						break;
					case CodeOp.AND:
						code.setDest(context, source1 && source2);
						break;
					case CodeOp.OR:
						code.setDest(context, source1 || source2);
						break;
					case CodeOp.RET:
						return source1;
						break;
					default:
						trace("unhandled op code:", code.getOp());
				}
				
				++codeIndex;
			}
			
			return null;
		}
	}
}