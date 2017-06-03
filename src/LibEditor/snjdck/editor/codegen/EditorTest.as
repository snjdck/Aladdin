package 
{
	import flash.display.DisplayObject;
	import flash.display.ImageControl;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileIO2;
	import flash.filesystem.FileUtil;
	import flash.geom.Point;
	import flash.http.loadMedia;
	import flash.support.Http;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import morn.core.components.View;
	
	import snjdck.editor.codegen.ClassDef;
	import snjdck.editor.codegen.ClassFactory;
	import snjdck.editor.codegen.ItemData;
	import snjdck.editor.codegen.PropInspector;
	import snjdck.editor.codegen.PropKeys;
	import snjdck.editor.control.ControlList;
	import snjdck.editor.menu.EditItemMenu;
	import snjdck.fileformat.zip.Zip;
	import snjdck.ui.tree.Tree;
	
	import stdlib.constant.KeyCode;
	
	[SWF(width="1000", height="600")]
	public class EditorTest extends Sprite
	{
		private var editArea:View = new View();
		private var control:ImageControl = new ImageControl();
		private var inspector:PropInspector = new PropInspector(control);
		private var controlList:ControlList = new ControlList();
		
		private var inspectorArea:Sprite = new Sprite();
		
		private var fileTree:Tree = new Tree();
		
		public function EditorTest()
		{
			$.root = this;
			inspectorArea.addChild(inspector);
			inspectorArea.x = stage.stageWidth - 200;
			
			editArea.width = stage.stageWidth;
			editArea.height = stage.stageHeight;
			
			fileTree.y = 300;
			fileTree.dataProvider = genFileTree(rootFile);
			fileTree.clickSignal.add(__onAddCustomView);
			
			controlList.dropSignal.add(__onAddControl);
			
			addChild(editArea);
			addChild(controlList);
			addChild(fileTree);
			addChild(inspectorArea);
			addChild(control);
			App.init(this);
			
			Http.Get("MornUILib.swc", null, function(ok:Boolean, data:ByteArray):void{
				var zip:Object = Zip.Parse(data);
				var context:LoaderContext = new LoaderContext(false, ClassDef.domain);
				context.allowCodeImport = true;
				loadMedia(zip["library.swf"], function(ok:Boolean, _:Object):void{
					ClassDef.init();
					Http.LoadDllList(["assets/comp.swf", "assets/vector.swf"], function():void{
						controlList.loadXML(XML(FileUtil.ReadString(new File("F:/FlashWorkSpace/Aladdin/src/LibEditor/snjdck/editor/control.xml"))));
					}, ApplicationDomain.currentDomain);
				}, null, context);
			});
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, __onKeyDown);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, __onEdit);
			EditItemMenu.Instance.attach(control);
		}
		
		private function __onAddCustomView(xml:XML):void
		{
			var fileDict:Object = genFileDict();
			var child:Sprite = ClassFactory.Instance.create(fileDict[xml.@data], fileDict) as Sprite;
			__onAddControl(child);
		}
		
		private function __onKeyDown(evt:KeyboardEvent):void
		{
			if(evt.keyCode == KeyCode.S && evt.controlKey){
				saveAll();
			}
		}
		
		private function __onAddControl(item:Sprite):void
		{
			var pt:Point = editArea.globalToLocal(new Point(item.x, item.y));
			item.x = pt.x;
			item.y = pt.y;
			editArea.addChild(item);
			new ItemData(item);
			EditItemMenu.Instance.attach(item);
		}
		
		private function __onEdit(evt:MouseEvent):void
		{
			if(evt.target == stage){
				control.setTarget(null);
				inspector.clearTargetInfo();
				return;
			}
			if(!editArea.contains(evt.target as DisplayObject)){
				return;
			}
			for(var i:int=editArea.numChildren-1; i>=0; --i){
				var child:Sprite = editArea.getChildAt(i) as Sprite;
				if(child.contains(evt.target as DisplayObject)){
					control.setTarget(child);
					return;
				}
			}
		}
		
		private function saveAll():void
		{
			var xml:XML = <View/>;
			for(var i:int=0; i<editArea.numChildren; ++i){
				var child:DisplayObject = editArea.getChildAt(i);
				xml.appendChild(PropKeys.Instance.castItemToXML(child));
			}
			FileUtil.WriteString(rootFile.resolvePath("a.xml"), xml.toXMLString());
			export();
		}
		//*
		private var rootFile:File = new File("C:/Users/Administrator/Documents/MyMornUI/morn/pages");
		private function export():void
		{
			var fileDict:Object = genFileDict();
			var writePath:File = rootFile.resolvePath("../release");
			
			for(var fileName:String in fileDict){
				var clsDef:ClassDef = new ClassDef();
				clsDef.loadXML(fileName, fileDict);
				FileUtil.WriteString(writePath.resolvePath(clsDef.filePath), clsDef.toString());
			}
		}
		
		private function genFileDict():Object
		{
			var fileDict:Object = {};
			FileIO2.Traverse(rootFile, function(f:File):Boolean{
				var key:String = rootFile.getRelativePath(f);
				fileDict[key] = XML(FileUtil.ReadString(f));
			});
			return fileDict;
		}
		
		private function genFileTree(file:File):XML
		{
			var result:XML = <node/>;
			if(file.isDirectory){
				for each(var f:File in file.getDirectoryListing()){
					if(file.isDirectory || file.extension == "xml"){
						result.appendChild(genFileTree(f));
					}
				}
				result.@label = file.name;
			}else{
				result.@label = file.name.slice(0, -4);
				result.@data = rootFile.getRelativePath(file);
			}
			return result;
		}
		//*/
	}
}

