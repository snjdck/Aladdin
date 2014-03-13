package flash.tcp.router
{
	import flash.utils.IDataInput;
	
	import lambda.call;

	internal class NoticeInfo
	{
		private var noticeId:uint;
		private var noticeType:Class;
		
		private var handler:Object;
		
		public function NoticeInfo(noticeId:uint, noticeType:Class, handler:Object)
		{
			this.noticeId = noticeId;
			this.noticeType = noticeType;
			this.handler = handler;
		}
		
		public function call(msgData:IDataInput):void
		{
			var notice:Object = null;
			if(null != noticeType){
				notice = new noticeType();
				notice.mergeFrom(msgData);
			}
			lambda.call(handler, notice);
		}
	}
}