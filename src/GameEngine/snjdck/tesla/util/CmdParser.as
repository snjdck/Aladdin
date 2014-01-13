package snjdck.tesla.util
{
	public class CmdParser
	{
		private var cmdDict:Object;
		
		public function CmdParser()
		{
			cmdDict = {};
		}
		
		public function regCmd(cmdName:String, handler:Function):void
		{
			cmdDict[cmdName] = handler;
		}
		
		public function hasCmd(cmdName:String):Boolean
		{
			return cmdDict[cmdName] != null;
		}
		
		public function isValidCmd(cmd:String):Boolean
		{
			if(cmd.charAt(0) != "/"){
				return false;
			}
			var spaceIndex:int = cmd.indexOf(" ");
			var cmdName:String = cmd.slice(1, (spaceIndex >= 0 ? spaceIndex : int.MAX_VALUE));
			return hasCmd(cmdName);
		}
		
		public function exec(cmd:String):void
		{
			if(cmd.charAt(0) != "/"){
				return;
			}
			var list:Array = cmd.slice(1).split(" ");
			var cmdName:String = list.shift();
			var handler:Function = cmdDict[cmdName];
			if(null == handler){
				return;
			}
			handler.apply(null, list);
		}
	}
}