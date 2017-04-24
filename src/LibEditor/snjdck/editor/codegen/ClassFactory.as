package snjdck.editor.codegen
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class ClassFactory
	{
		public function ClassFactory()
		{
		}
		
		public function create(targetDef:XML, fileDict:Object):DisplayObject
		{
			var target:DisplayObject;
			var targetType:String = targetDef.name();
			if(targetType == "UIView"){
				target = create(fileDict[targetDef["@source"]], fileDict);
			}else{
				var clazz:Object = ClassDef.domain.getDefinition(ClassDef.getPackage(targetType));
				target = new clazz();
			}
			setProp(targetDef, target, fileDict);
			for each(var childDef:XML in targetDef.children()){
				var child:DisplayObject = create(childDef, fileDict);
				(target as DisplayObjectContainer).addChild(child);
			}
			return target;
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
	}
}