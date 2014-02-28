package flash.support
{
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	
	import flash.http.loadData;

	final public class Uploader
	{
		static private const UPLOAD_BOUNDARY:String = "----------Ij5GI3GI3ei4GI3ei4KM7GI3KM7KM7";
		static private const DOUBLE_DASH:String = "--";
		static private const VK_RETURN:String = "\r\n";
		
		static public function Upload(path:String, extraData:Object, fileName:String, fileData:ByteArray, handler:Function):void
		{
			var request:URLRequest = new URLRequest(path);
			
			request.method = URLRequestMethod.POST;
			request.requestHeaders.push(new URLRequestHeader("Cache-Control", "no-cache"));
			request.contentType = "multipart/form-data; boundary=" + UPLOAD_BOUNDARY;
			request.data = GetFileUploadData(fileName, fileData, extraData);
			
			loadData(request, handler);
		}
		
		static private function GetFileUploadData(fileName:String, fileData:ByteArray, extraData:Object):ByteArray
		{
			var result:ByteArray = new ByteArray();
			
			var list:Array = [];
			list.push(["Filename", fileName]);//文件名
			if(null != extraData){
				for(var key:String in extraData){
					list.push([key, extraData[key]]);//附加参数
				}
			}
			list.push(["Upload", "Submit Query"]);//提交请求
			
			for(var i:int=0, n:int=list.length; i<n; i++)
			{
				if(i == n-1)
				{
					//文件数据
					result.writeUTFBytes(DOUBLE_DASH + UPLOAD_BOUNDARY + VK_RETURN);
					result.writeUTFBytes('Content-Disposition: form-data; name="Filedata"; filename="' + fileName + '"');
					result.writeUTFBytes(VK_RETURN);
					result.writeUTFBytes("Content-Type: application/octet-stream");
					result.writeUTFBytes(VK_RETURN + VK_RETURN);
					result.writeBytes(fileData);
					result.writeUTFBytes(VK_RETURN);
				}
				result.writeUTFBytes(DOUBLE_DASH + UPLOAD_BOUNDARY + VK_RETURN);
				result.writeUTFBytes('Content-Disposition: form-data; name="' + list[i][0] + '"');
				result.writeUTFBytes(VK_RETURN + VK_RETURN);
				result.writeUTFBytes(list[i][1]);
				result.writeUTFBytes(VK_RETURN);
			}
			
			//结束标记
			result.writeUTFBytes(DOUBLE_DASH + UPLOAD_BOUNDARY + DOUBLE_DASH + VK_RETURN);
			
			return result;
		}
	}
}