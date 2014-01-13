package snjdck.mvc.helper
{
	import stdlib.common.eval;
	import snjdck.mvc.Msg;
	import snjdck.mvc.helper.argType.IArgType;
	
	[ExcludeClass]
	public class MsgHandlerInfo
	{
		private var handler:Function;
		private var argType:IArgType;
		private var filterKey:String;
		
		public function MsgHandlerInfo(handler:Function, argType:IArgType, filterKey:String)
		{
			this.handler = handler;
			this.argType = argType;
			this.filterKey = filterKey;
		}
		
		public function exec(msg:Msg, actorId:String):void
		{
			if(filterKey != null){
				if(filterKey.length > 0){
					if(!(actorId && eval(msg.data, filterKey) == actorId)){
						return;
					}
				}else{
					if(msg.data != filterKey){
						return;
					}
				}
			}
			argType.exec(handler, msg);
		}
	}
}