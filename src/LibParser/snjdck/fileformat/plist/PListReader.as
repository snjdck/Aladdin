package snjdck.fileformat.plist
{
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class PListReader
	{
		public function PListReader()
		{
		}
		
		public function read(source:XML):Object
		{
			var nodeName:String = source.localName();
			switch(nodeName)
			{
				case "string":
					return source.toString();
				case "dict":
					return readDict(source);
				case "true":
					return true;
				case "false":
					return false;
				case "integer":
					return parseInt(source.toString());
				case "real":
					return parseFloat(source.toString());
				case "plist":
					return readDict(source.children()[0]);
				case "array":
			}
			throw new Error("not support yet!" + nodeName);
		}
		
		private function readDict(source:XML):Object
		{
			var result:Object = {};
			var children:XMLList = source.children();
			
			for(var i:int=0, n:int=children.length(); i<n; i+=2){
				var key:String = children[i];
				var value:Object = read(children[i+1]);
				result[key] = processDictValue(key, value);
			}
			
			return result;
		}
		
		private function processDictValue(key:String, value:*):Object
		{
			if(!(value is String)){
				return value;
			}
			switch(key)
			{
				case "size":
				case "offset":
				case "sourceSize":
					return str2point(value);
				case "frame"://位置, 宽高
				case "sourceColorRect":
					return str2rect(value);
			}
			return value;
		}
		
		private function str2point(str:String):Point
		{
			var index:int = str.indexOf(",");
			var px:Number = parseFloat(str.slice(1, index));
			var py:Number = parseFloat(str.slice(index+1, -1));
			return new Point(px, py);
		}
		
		private function str2rect(str:String):Rectangle
		{
			var index:int = str.indexOf(",{");
			var xy:Point = str2point(str.slice(1, index));
			var wh:Point = str2point(str.slice(index+1, -1));
			return new Rectangle(xy.x, xy.y, wh.x, wh.y);
		}
	}
}