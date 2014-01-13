package snjdck.mvc.imp
{
	import flash.utils.Dictionary;
	
	import array.del;
	
	import dict.hasKey;
	
	import snjdck.mvc.Msg;
	import snjdck.mvc.MsgName;
	import snjdck.mvc.ns_mvc;
	import snjdck.mvc.core.IController;
	
	import snjdck.injector.IInjector;

	public class Controller implements IController
	{
		[Inject]
		public var injector:IInjector;
		
		private const cmdRefs:Object = new Dictionary();
		
		public function Controller()
		{
		}
		
		public function regCmd(msgName:MsgName, cmdCls:Class):void
		{
			if(!hasCmd(msgName, cmdCls)){
				var list:Array = cmdRefs[msgName];
				if(list){
					list.push(cmdCls);
				}else{
					cmdRefs[msgName] = [cmdCls];
				}
			}
		}
		
		public function delCmd(msgName:MsgName, cmdCls:Class):void
		{
			if(hasCmd(msgName, cmdCls)){
				array.del(cmdRefs[msgName], cmdCls);
			}
		}
		
		public function hasCmd(msgName:MsgName, cmdCls:Class):Boolean
		{
			if(hasKey(cmdRefs, msgName)){
				return array.has(cmdRefs[msgName], cmdCls);
			}
			return false;
		}
		
		ns_mvc function execCmds(msg:Msg):void
		{
			if(msg.isProcessCanceled()){
				return;
			}
			
			var list:Array = cmdRefs[msg.name];
			
			if(null == list || list.length < 1){
				return;
			}
			
			injector.mapValue(Msg, msg, null, false);
			
			for each(var cmdCls:Class in list){
				var cmd:Command = injector.newInstance(cmdCls);
				cmd.exec();
				if(msg.isProcessCanceled()){
					break;
				}
			}
			
			injector.unmap(Msg);
		}
	}
}