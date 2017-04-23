package snjdck.editor.codegen
{
	import flash.debugger.enterDebugger;
	import flash.display.Sprite;
	import flash.filesystem.File;
	import flash.filesystem.FileIO;
	import flash.filesystem.FileIO2;
	import flash.filesystem.FileUtil;
	import flash.http.loadMedia;
	import flash.support.Http;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import snjdck.editor.codegen.ClassDef;
	import snjdck.fileformat.zip.Zip;
	
	import string.endWith;
	
	public class EditorTest extends Sprite
	{
		protected static var uiXML:XML =
			<View width="960" height="540">
			  <TeachRecordView x="223" y="119" var="teachRecordView" runtime="modules.dataquery.classinfo.TeachRecordView"/>
			  <Box x="411" y="95" var="studentDataMenu">
				<Button label="个人成绩" skin="png.comp.button" y="0" x="0" visible="false"/>
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
			  <ClassSummaryView x="3" y="-3" var="classSummaryView" name="alex" runtime="modules.dataquery.classinfo.ClassSummaryView"/>
			</View>;
		
		public function EditorTest()
		{
			Http.Get("MornUILib.swc", null, function(ok:Boolean, data:ByteArray):void{
				var zip:Object = Zip.Parse(data);
				var context:LoaderContext = new LoaderContext(false, ClassDef.domain);
				context.allowCodeImport = true;
				loadMedia(zip["library.swf"], function(ok:Boolean, _:Object):void{
					ClassDef.init();
					init();
				}, null, context);
			});
		}
		
		
		
		private function init():void
		{
			
			
			var fileDict:Object = {};
			
			var file:File = new File("C:/Users/Alex/Documents/MyMornUI/morn/pages");
			FileIO2.Traverse(file, function(f:File):Boolean{
				var key:String = file.getRelativePath(f);
				fileDict[key] = XML(FileIO2.Read(f).toString());
				key.slice(0, -4).replace(/\//g, ".");
			});
			//enterDebugger();
			var writePath:File = new File("E:/flashWorkspace/EditorTest/src");
			
			for(var fileName:String in fileDict){
				var clsDef:ClassDef = new ClassDef();
				clsDef.fullName = fileName.slice(0, -4).replace(/\//g, ".");
				clsDef.loadXML(fileDict[fileName], fileDict);
				trace(clsDef.toString());
			}
		}
	}
}