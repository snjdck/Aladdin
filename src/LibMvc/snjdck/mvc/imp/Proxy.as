package snjdck.mvc.imp
{
	import flash.utils.Dictionary;
	
	import dict.addKey;
	import dict.deleteKey;
	
	import snjdck.mvc.Module;
	import snjdck.mvc.Msg;
	import snjdck.mvc.MsgName;
	import snjdck.mvc.ns_mvc;
	import snjdck.mvc.core.INotifier;
	
	use namespace ns_mvc;

	public class Proxy implements INotifier
	{
		private var moduleList:Object;
		private var initFlag:Boolean;
		
		public function Proxy()
		{
			moduleList = new Dictionary();
		}
		
		internal function regToModule(module:Module):void
		{
			addKey(moduleList, module);
			
			if(!initFlag){
				initFlag = true;
				this.onInit();
			}
			
			this.onReg(module);
		}
		
		internal function delFromModule(module:Module):void
		{
			this.onDel(module);
			deleteKey(moduleList, module);
		}
		
		final public function notify(msgName:MsgName, msgData:Object=null):Boolean
		{
			for(var module:* in moduleList){
				(module as Module).notifyImp(new Msg(msgName, msgData, this));
			}
			return true;
		}
		
		protected function onInit():void{}
		protected function onReg(module:Module):void{}
		protected function onDel(module:Module):void{}
	}
}