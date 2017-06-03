package snjdck.editor.codegen
{
	import flash.display.DisplayObject;
	import flash.reflection.getTypeName;

	public class PropKeys
	{
		static private const sizeName:Array = ["x", "y", "width", "height", "centerX", "centerY", "left", "right", "top", "bottom"];
		static public const Instance:PropKeys = new PropKeys();
		
		private var infoDict:Object = {};
		
		public function PropKeys()
		{
			infoDict["Button"] = ["var", "name"].concat(sizeName);
			infoDict["Image"] =  ["var", "name"].concat(sizeName);
			infoDict["View"] =  ["name", "runtime"].concat(sizeName);
		}
		
		public function getKeys(type:String):Array
		{
			return infoDict[type];
		}
		
		public function castItemToXML(target:DisplayObject):XML
		{
			var typeName:String = getTypeName(target, true);
			var node:XML = XML("<" + typeName + "/>")
			var keyList:Array = getKeys(typeName);
			for each(var key:String in keyList){
				var value:* = ItemData.getKey(target, key);
				if(value === ""){
					continue;
				}
				node.@[key] = value;
			}
			return node;
		}
	}
}