package snjdck.interpreter
{
	import snjdck.arithmetic.IExecutable;

	public class Code
	{
		private var dest:String;
		private var op:String;
		private var source1:IExecutable;
		private var source2:IExecutable;
		
		public function Code(dest:String, op:String, source1:IExecutable, source2:IExecutable)
		{
			this.dest = dest;
			this.op = op;
			this.source1 = source1;
			this.source2 = source2;
		}
		
		public function getOp():String
		{
			return op;
		}
		
		public function getSource1(context:ExecContext):Object
		{
			return source1 && source1.calculate(context);
		}
		
		public function getSource2(context:ExecContext):Object
		{
			return source2 && source2.calculate(context);
		}
		
		public function setDest(context:ExecContext, value:Object):void
		{
			context.setValue(dest, value);
		}
	}
}