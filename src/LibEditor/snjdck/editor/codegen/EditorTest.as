package
{
	import flash.display.Sprite;
	import flash.filesystem.File;
	import flash.filesystem.FileIO2;
	import flash.filesystem.FileUtil;
	import flash.http.loadMedia;
	import flash.support.Http;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import snjdck.editor.codegen.ClassDef;
	import snjdck.fileformat.zip.Zip;
	
	import test.Test1UI;
	import test.Test2UI;

	//Test1UI;
	//Test2UI;
	
	public class EditorTest extends Sprite
	{
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
			var writePath:File = new File("C:/Users/Alex/Documents/MyMornUI/morn/release");
			
			FileIO2.Traverse(file, function(f:File):Boolean{
				var key:String = file.getRelativePath(f);
				fileDict[key] = XML(FileUtil.ReadString(f));
			});
			for(var fileName:String in fileDict){
				var clsDef:ClassDef = new ClassDef();
				clsDef.fullName = fileName.slice(0, -4).replace(/\//g, ".");
				clsDef.loadXML(fileDict[fileName], fileDict);
				FileUtil.WriteString(writePath.resolvePath(clsDef.filePath), clsDef.toString());
			}
		}
	}
}