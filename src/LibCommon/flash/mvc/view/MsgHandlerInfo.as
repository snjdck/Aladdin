package flash.mvc.view
{
	import flash.mvc.notification.Msg;
	import flash.mvc.view.argType.IArgType;
	
	import stdlib.common.eval;
	
	internal class MsgHandlerInfo
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