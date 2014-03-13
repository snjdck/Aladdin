package flash.tcp
{
	public interface IPacketRouter
	{
		function regRequest(
			requestId:uint, requestType:Class,
			responseId:uint=0, responseType:Class=null,
			errorId:uint=0
		):void;
		
		function regNotice(
			noticeId:uint, noticeType:Class,
			handler:Object
		):void;
	}
}