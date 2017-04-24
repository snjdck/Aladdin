package snjdck.editor.codegen
{
	import flash.reflection.typeinfo.TypeInfo;
	import flash.system.ApplicationDomain;
	
	import array.pushIfNotHas;
	
	import avmplus.describeType2;
	
	import string.repeat;
	import string.replace;

	public class ClassDef
	{
		static public const domain:ApplicationDomain = new ApplicationDomain();
		static private const packageDict:Object = {};
		static private const infoDict:Object = {};
		static private function getPackage(clsName:String):String
		{
			if(packageDict[clsName] == null){
				throw new Error();
			}
			return packageDict[clsName];
		}
		
		static public function init():void
		{
			var list:Vector.<String> = domain.getQualifiedDefinitionNames();
			for(var i:int=0, n:int=list.length; i<n; ++i){
				var name:String = list[i];
				var info:TypeInfo = new TypeInfo(describeType2(domain.getDefinition(name)));
				if(info.isExtends("flash.display::DisplayObject")){
					var key:String = name.split("::").pop();
					packageDict[key] = name.replace("::", ".");
					infoDict[key] = info.variables;
				}
			}
		}
		
		public var packageName:String;
		public var importList:Array = [];
		public var parentClassName:String;
		public var className:String;
		public var fieldDict:Object = {};
		public const constructorCode:Array = [];
		
		private var _indent:int;
		private const _lineList:Array = [];
		private var _childCount:int;
		
		public function ClassDef()
		{
		}
		
		public function set fullName(value:String):void
		{
			var index:int = value.lastIndexOf(".");
			if(index < 0){
				packageName = "";
				className = value;
			}else{
				packageName = value.slice(0, index);
				className = value.slice(index+1);
			}
		}
		
		public function loadXML(xml:XML, fileDict:Object):void
		{
			parentClassName = xml.name();
			genPropCode(xml, "this", parentClassName);
			addImport(getPackage(parentClassName));
			
			for each(var childDef:XML in xml.children()){
				parse(childDef, "this", fileDict);
			}
			importList.sort();
		}
		
		private function addImport(path:String):void
		{
			var list:Array = path.split(".");
			list.pop();
			if(list.join(".") == packageName){
				return;
			}
			pushIfNotHas(importList, path);
		}
		
		private function addCode(template:String, args:Array=null):void
		{
			constructorCode.push(replace(template, args));
		}
		
		private function parse(targetDef:XML, parent:String, fileDict:Object):void
		{
			var targetName:String = calcTargetName();
			var targetType:String = targetDef.name();
			
			var importPath:String = targetDef["@runtime"];
			if(Boolean(importPath)){
				addImport(importPath);
			}else if(targetType == "UIView"){
				addImport(targetDef["@source"].slice(0, -4).split("/").join("."));
			}else{
				addImport(getPackage(targetType));
			}
			
			if(targetType == "UIView"){
				if(importPath){
					targetType = importPath.split(".").pop();
				}else{
					targetType = targetDef["@source"].slice(0, -4).split("/").pop();
				}
			}
			
			var varName:String = targetDef["@var"];
			if(Boolean(varName)){
				targetName = varName;
				addCode("${0} = new ${1}();", [targetName, targetType]);
				fieldDict[targetName] = targetType;
			}else{
				addCode("var ${0}:${1} = new ${1}();", [targetName, targetType]);
			}
			
			addCode("${0}.addChild(${1});", [parent, targetName]);
			
			if(targetDef.name().toString() == "UIView"){
				targetType = fileDict[targetDef["@source"]].name();
			}
			genPropCode(targetDef, targetName, targetType);
			
			for each(var childDef:XML in targetDef.children()){
				parse(childDef, targetName, fileDict);
			}
		}
		
		private function genPropCode(targetDef:XML, targetName:String, targetType:String):void
		{
			for each(var prop:XML in targetDef.attributes()){
				var key:String = prop.name();
				var info:Object = infoDict[targetType][key];
				if(info == null){
					continue;
				}
				var value:String = genValueString(info.type, prop);
				addCode("${0}.${1} = ${2};", [targetName, key, value]);
			}
			addCode("");
		}
		
		private function genValueString(type:String, value:String):String
		{
			switch(type){
				case "String":
					return replace('"${0}"', [value]);
				case "Boolean":
					return (value == "true").toString();
			}
			return value;
		}
		
		private function calcTargetName():String
		{
			return "child_" + (_childCount++);
		}
		
		public function toString():String
		{
			addLine("package ${packageName}");
			beginDefine();
			for each(var importName:String in importList){
				addLine(replace("import ${0};", [importName]));
			}
			addLine("");
			addLine("public class ${className} extends ${parentClassName}");
			beginDefine();
			for(var fieldName:String in fieldDict){
				addLine(replace("public var ${0}:${1};", [fieldName, fieldDict[fieldName]]));
			}
			addLine("");
			addLine("public function ${className}()");
			beginDefine();
			for each(var code:String in constructorCode){
				addLine(code);
			}
			endDefine();
			endDefine();
			endDefine();
			return replace(_lineList.join("\n"), this);
		}
		
		private function addLine(line:String):void
		{
			_lineList.push(printTab(_indent) + line);
		}
		
		private function printTab(count:int):String
		{
			return repeat("\t", count);
		}
		
		private function beginDefine():void
		{
			addLine("{");
			++_indent;
		}
		
		private function endDefine():void
		{
			--_indent;
			addLine("}");
		}
	}
}
