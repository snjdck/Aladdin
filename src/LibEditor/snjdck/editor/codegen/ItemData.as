package snjdck.editor.codegen
{
	import flash.display.DisplayObject;
	
	import math.isNumber;

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
		
		public function ItemData(target:DisplayObject)
		{
			this.target = target;
			target.metaData = this;
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
				return "";
			}
			if(isNumber(value) && isNaN(value)){
				return "";
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