package flash.http
{
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	
	import flash.system.isAdobeAir;

	internal function configHttpHeader(request:URLRequest, headerDict:Object):void
	{
		var list:Array = request.requestHeaders;
		if(isAdobeAir()){
			list.push(new URLRequestHeader("Referer", request.url));
		}
		for(var headerName:String in headerDict){
			list.push(new URLRequestHeader(headerName, headerDict[headerName]));
		}
	}
}