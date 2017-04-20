package snjdck.editor.codegen
{
	public class ClassDef
	{
		protected static var uiXML:XML =
			<View width="960" height="540">
			  <TeachRecordView x="223" y="119" var="teachRecordView" runtime="modules.dataquery.classinfo.TeachRecordView"/>
			  <Box x="411" y="95" var="studentDataMenu">
				<Button label="个人成绩" skin="png.comp.button" y="0" x="0"/>
				<Button label="基本信息" skin="png.comp.button" x="80" y="0"/>
				<Button label="积分贡献" skin="png.comp.button" x="160" y="0"/>
			  </Box>
			  <ClassProgressView x="2" y="2" var="classProgressView" runtime="modules.dataquery.classinfo.ClassProgressView"/>
			  <Button label="班级数据" skin="png.comp.button" x="292" y="64" var="classDataBtn"/>
			  <Button label="小组数据" skin="png.comp.button" x="392" y="64" var="teamDataBtn"/>
			  <Button label="学生数据" skin="png.comp.button" x="492" y="64" stateNum="3" var="studentDataBtn"/>
			  <Button label="APP数据" skin="png.comp.button" x="592" y="64" var="appDataBtn"/>
			  <Box x="214" y="96" visible="false" var="classDataMenu">
				<Button label="课程进度" skin="png.comp.button" y="0" x="0" var="classProgress"/>
				<Button label="教学记录" skin="png.comp.button" x="80" y="0" var="teachRecord"/>
				<Button label="课程总结" skin="png.comp.button" x="160" y="0"/>
			  </Box>
			  <Box x="392" y="97" var="groupDataMenu">
				<Button label="小组信息" skin="png.comp.button"/>
			  </Box>
			  <Box x="512" y="94" var="appDataMenu">
				<Button label="时间数据" skin="png.comp.button" y="0" x="0"/>
				<Button label="单词收藏" skin="png.comp.button" x="84" y="0"/>
				<Button label="单词检测" skin="png.comp.button" x="168" y="0"/>
				<Button label="课后检测" skin="png.comp.button" x="252" y="0"/>
			  </Box>
			  <ClassSummaryView x="3" y="-3" var="classSummaryView" runtime="modules.dataquery.classinfo.ClassSummaryView"/>
			</View>;
		
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
			genPropCode(uiXML, "this");
			for each(var childDef:XML in uiXML.children()){
				parse(childDef, "this");
			}
		}
		
		private function parse(targetDef:XML, parent:String):void
		{
			var targetName:String = calcTargetName();
			var targetType:String = targetDef.name();
			
			var varName:String = targetDef["@var"];
			if(Boolean(varName)){
				targetName = varName;
				constructorCode.push(targetName + " = new " + targetType + "()");
				fieldDict[targetName] = targetType;
			}else{
				constructorCode.push("var " + targetName + ":" + targetType + " = new " + targetType + "()");
			}
			
			constructorCode.push(parent + ".addChild(" + targetName + ")");
			
			var importPath:String = targetDef["@runtime"];
			if(Boolean(importPath)){
				importList.push(importPath);
			}
			
			genPropCode(targetDef, targetName);
			
			if(targetDef.hasSimpleContent()){
				return;
			}
			for each(var childDef:XML in targetDef.children()){
				parse(childDef, targetName);
			}
		}
		
		private function genPropCode(targetDef:XML, targetName:String):void
		{
			for each(var prop:XML in targetDef.attributes()){
				var key:String = prop.name();
				switch(key){
					case "var":
					case "runtime":
						continue;
				}
				var value:String = prop.toString();
				constructorCode.push(targetName + "." + key + " = " + value);
			}
			constructorCode.push("\n");
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
				addLine("import " + importName + ";");
			}
			addLine("");
			addLine("public class ${className} extends ${parentClassName}");
			beginDefine();
			for(var fieldName:String in fieldDict){
				addLine("public var " + fieldName + ":" + fieldDict[fieldName] + ";");
			}
			addLine("");
			addLine("public function ${className}()");
			beginDefine();
			for each(var code:String in constructorCode){
				addLine(code + ";");
			}
			endDefine();
			endDefine();
			endDefine();
			return _lineList.join("\n").replace(/\n;/g, "");
		}
		
		private function addLine(line:String):void
		{
			_lineList.push(printTab(_indent) + line);
		}
		
		private function printTab(count:int):String
		{
			var result:String = "";
			for(var i:int=0; i<count; ++i){
				result += "\t";
			}
			return result;
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
