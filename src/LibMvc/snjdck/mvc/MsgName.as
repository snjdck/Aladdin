package snjdck.mvc
{
	use namespace ns_mvc;

	public class MsgName
	{
		private var desc:String;
		
		public function MsgName(desc:String=null)
		{
			this.desc = desc;
		}
		
		public function toString():String
		{
			return desc;
		}
		
		private var parent:MsgName;
		ns_mvc var isReply:Boolean;
		
		private function createSubMsg(isReply:Boolean):MsgName
		{
			var msgName:MsgName = new MsgName();
			msgName.parent = this;
			msgName.isReply = isReply;
			return msgName;
		}
		
		private var reply:MsgName;
		final public function get REPLY():MsgName
		{
			if(parent){
				return null;
			}
			return reply ||= createSubMsg(true);
		}
	}
}