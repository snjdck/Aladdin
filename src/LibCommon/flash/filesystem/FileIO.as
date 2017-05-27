package flash.filesystem
{
	import flash.events.Event;
	import flash.net.FileReference;
	
	final public class FileIO
	{
		static private const fr:FileReference = new FileReference();
		
		static public function Save(data:*, handler:Function=null, defaultFileName:String=null):void
		{
			fr.addEventListener(Event.CANCEL, __onResult);
			fr.addEventListener(Event.COMPLETE, __onResult);
			
			fr.save(data, defaultFileName);
			
			function __onResult(evt:Event):void
			{
				fr.removeEventListener(Event.CANCEL, __onResult);
				fr.removeEventListener(Event.COMPLETE, __onResult);
				$lambda.execFunc(handler, evt.type == Event.COMPLETE);
			}
		}
		
		/** 获取文件名,如test.jpg => test */
		static public function GetName(filePath:String):String
		{
			var index:int = filePath.lastIndexOf(".");
			if(-1 != index){
				return filePath.slice(0, index);
			}
			return filePath;
		}
		
		/** 获取文件扩展名,如test.jpg => jpg */
		static public function GetExt(filePath:String):String
		{
			var index:int = filePath.lastIndexOf(".");
			if(-1 != index){
				return filePath.slice(index+1);
			}
			return null;
		}
		
		/**
		 * 获取文件路径的目录地址<br>
		 * http://www.web.com/login.php?name=admin 返回 http://www.web.com/
		 */
		static public function GetDirPath(filePath:String):String
		{
			var result:String = filePath;
			
			var index:int = result.indexOf("?");
			if(index != -1){
				result = result.slice(0, index);
			}
			
			index = result.lastIndexOf("/");
			if(index < 0){
				return "";
			}
			
			return result.slice(0, index+1);
		}
	}
}