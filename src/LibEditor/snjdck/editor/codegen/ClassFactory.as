package snjdck.editor.codegen
{
	import flash.accessibility.AccessibilityProperties;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

	public class ClassFactory
	{
		static public const Instance:ClassFactory = new ClassFactory();
		
		public function ClassFactory()
		{
		}
		
		public function create(targetDef:XML, fileDict:Object):Sprite
		{
			var target:DisplayObject;
			var targetType:String = targetDef.name();
			if(targetType == "UIView"){
				target = create(fileDict[targetDef["@source"]], fileDict);
				setViewSource(target, targetDef["@source"]);
			}else{
				target = $lambda.apply(ClassDef.getPackage(targetType));
			}
			setProp(targetDef, target, fileDict);
			for each(var childDef:XML in targetDef.children()){
				var child:DisplayObject = create(childDef, fileDict);
				(target as DisplayObjectContainer).addChild(child);
			}
			return target as Sprite;
		}
		
		private function setProp(targetDef:XML, target:Object, fileDict:Object):void
		{
			var targetType:String = targetDef.name();
			if(targetType == "UIView"){
				targetType = fileDict[targetDef["@source"]].name();
			}
			for each(var prop:XML in targetDef.attributes()){
				var key:String = prop.name();
				var info:Object = ClassDef.infoDict[targetType][key];
				if(info == null){
					continue;
				}
				target[key] = calcValue(info.type, prop);
			}
			if(!targetDef.hasOwnProperty("@name")){
				target.name = "";
			}
		}
		
		private function calcValue(type:String, value:String):*
		{
			switch(type){
				case "String":
					return value;
				case "Boolean":
					return value == "true";
			}
			return parseFloat(value);
		}
		
		static public function setViewSource(target:DisplayObject, source:String):void
		{
			target.accessibilityProperties = new AccessibilityProperties();
			target.accessibilityProperties.name = source;
		}
	}
}