package flash.mvc.notification
{
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
	}
}