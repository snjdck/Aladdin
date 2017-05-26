package snjdck.editor.codegen
{
	import flash.display.DisplayObject;

	public class ItemData
	{
		static public function getKey(target:DisplayObject, key:String):*
		{
			return (target.metaData as ItemData).getKey(key);
		}
		
		static public function setKey(target:DisplayObject, key:String, value:*):void
		{
			(target.metaData as ItemData).setKey(key, value);
		}
		
		private var target:DisplayObject;
		private var keyDict:Object = {};
		
//		static private const reserved:Array = ["visible", "mouseChildren", ];
		
		public function ItemData(target:DisplayObject)
		{
			this.target = target;
			target.metaData = this;
//			keyDict["mouseEnabled"] = target["mouseEnabled"];
//			keyDict["mouseChildren"] = target["mouseChildren"];
//			keyDict["visible"] = target.visible;
		}
		
		public function getKey(key:String):*
		{
			var value:*;
			if(target.hasOwnProperty(key)){
				value = target[key];
			}else{
				value = keyDict[key];
			}
			if(value == null){
				value = "";
			}
			return value;
		}
		
		public function setKey(key:String, value:*):void
		{
			if(target.hasOwnProperty(key)){
				target[key] = value;
			}else{
				keyDict[key] = value;
			}
		}
	}
}