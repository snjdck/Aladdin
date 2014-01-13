package snjdck.interpreter
{
	import flash.display.Sprite;
	import flash.utils.getTimer;
	
	import snjdck.interpreter.ExecContext;
	import snjdck.interpreter.FuncData;
	import snjdck.interpreter.node.ValueNode;
	import snjdck.interpreter.node.VarNode;
	
	public class TestProj extends Sprite
	{
		public function TestProj()
		{
			const n:int = 25;
			
			var ctx:ExecContext = new ExecContext(null);
			ctx.setValue("sk", n);
			
			var a:int, b:int, c:int;
			var r1:int, r2:*;
			
			a = getTimer();
			r1 = test1(n);
			b = getTimer();
			r2 = new FuncData(null, null).exec([new VarNode("sk")], ctx)
			c = getTimer();
			trace(r1,r2,b-a, c-b);
		}
		
		private function test1(n:int):int
		{
			if(0 == n || 1 == n){
				return n;
			}
			return test1(n-2) + test1(n-1);
		}
	}
}