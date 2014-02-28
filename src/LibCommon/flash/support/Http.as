package flash.support
{
	import flash.lang.ICloseable;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	import lambda.call;
	
	import http.loadData;
	
	import protocols.Rpc;
	
	import stdlib.common.copyProps;
	
	final public class Http
	{
		static public function Call(gateway:String, cmd:String, args:Array, handler:Function):ICloseable
		{
			var request:URLRequest = new URLRequest(gateway);
			request.method = URLRequestMethod.POST;
			request.contentType = "application/x-amf";
			request.data = Rpc.Encode(cmd, args || []);
			return loadData(request, [__onCall, handler]);
		}
		
		static private function __onCall(ok:Boolean, data:*, handler:Object):void
		{
			if(ok){
				try{
					var obj:Array = Rpc.Decode(data);
					ok = obj[0];
					data = obj[1];
				}catch(e:Error){
					ok = false;
					data = "amf data format error!";
				}
			}
			lambda.call(handler, ok, data);
		}
		
		static public function Get(path:String, extraData:Object, handler:Object, progress:Function=null, headerDict:Object=null):ICloseable
		{
			var request:URLRequest = new URLRequest(path);
			request.data = extraData && copyProps(new URLVariables(), extraData);
			return loadData(request, handler, progress, headerDict);
		}
		
		static public function Post(path:String, extraData:Object, handler:Object, progress:Function=null, headerDict:Object=null):ICloseable
		{
			var request:URLRequest = new URLRequest(path);
			request.method = URLRequestMethod.POST;
			
			if(extraData){
				if(extraData is ByteArray){
					request.contentType = "application/octet-stream";
					request.data = extraData;
				}else if(extraData is XML){//发送XML, xml会转成字符串再发送
					request.contentType = "text/xml; charset=utf-8";
					request.data = (extraData as XML).toXMLString();
				}else if(extraData is URLVariables){
					request.data = extraData;
				}else{
					request.contentType = "text/plain; charset=utf-8";
					request.data = (extraData is String) ? extraData : JSON.stringify(extraData);
				}
			}
			
			return loadData(request, handler, progress, headerDict);
		}
	}
}