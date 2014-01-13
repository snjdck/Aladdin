package snjdck
{
	public class BrainFuck
	{
		private const memory:Vector.<int> = new Vector.<int>(0x10000, true);
		private var opIndex:int = 0;
		
		public function BrainFuck()
		{
			//hello world!
			exec("++++++++++[>+++++++>++++++++++>+++>+<<<<-]>++.>+.+++++++..+++.>++.<<+++++++++++++++.>.+++.------.--------.>+.>.");
		}
		
		public function exec(code:String):void
		{
			var i:int = 0;
			var n:int = code.length;
			while(i < n)
			{
				switch(code.charAt(i))
				{
					case ">":
						++opIndex;
						break;
					case "<":
						--opIndex;
						break;
					case "+":
						memory[opIndex] = (memory[opIndex] + 1) & 0xFF;
						break;
					case "-":
						memory[opIndex] = (memory[opIndex] - 1) & 0xFF;
						break;
					case ".":
						trace(String.fromCharCode(memory[opIndex]));
						break;
					case ",":
						break;
					case "[":
						if(0 == memory[opIndex]){
							i = find(code, i, code.length, 1);
							continue;
						}
						break;
					case "]":
						if(0 != memory[opIndex]){
							i = find(code, i, -1, -1);
							continue;
						}
						break;
				}
				++i;
			}
		}
		
		private function find(code:String, from:int, to:int, step:int):int
		{
			var count:int = 0;
			for(var i:int=from; i != to; i += step){
				switch(code.charAt(i)){
					case "[":
						++count;
						break;
					case "]":
						--count;
						break;
				}
				if(0 == count){
					return i + 1;
				}
			}
			return -1;
		}
	}
}