package system
{
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	
	import stdlib.common.copyProps;

	public function getURL(path:String, params:Object=null):void
	{
		var request:URLRequest = new URLRequest(path);
		request.data = copyProps(new URLVariables(), params);
		navigateToURL(request);
	}
}