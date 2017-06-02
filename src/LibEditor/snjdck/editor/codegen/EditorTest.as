package 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.ImageControl;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileIO2;
	import flash.filesystem.FileUtil;
	import flash.geom.Point;
	import flash.http.loadMedia;
	import flash.reflection.getTypeName;
	import flash.support.Http;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import morn.core.components.Button;
	import morn.core.components.Image;
	import morn.core.components.View;
	import morn.core.handlers.Handler;
	
	import snjdck.editor.codegen.ClassDef;
	import snjdck.editor.codegen.ItemData;
	import snjdck.editor.codegen.PropInspector;
	import snjdck.editor.codegen.PropKeys;
	import snjdck.editor.control.ControlList;
	import snjdck.editor.menu.EditItemMenu;
	import snjdck.fileformat.zip.Zip;
	import snjdck.ui.tree.Tree;
	
	import stdlib.constant.KeyCode;
	
	import test.Test1UI;
	import test.Test2UI;

	Test1UI;
	Test2UI;
	aUI;
	
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
			fileTree.dataProvider = genFileTree(file);
			
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
					App.loader.loadAssets(["assets/comp.swf", "assets/vector.swf"], new Handler(function():void{
						controlList.loadXML(XML(FileUtil.ReadString(new File("F:/FlashWorkSpace/Aladdin/src/LibEditor/snjdck/editor/control.xml"))));
					}));
				}, null, context);
			});
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, __onKeyDown);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, __onEdit);
			EditItemMenu.Instance.attach(control);
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
//			listenEvent(item);
			EditItemMenu.Instance.attach(item);
		}
//		
//		private function listenEvent(target:InteractiveObject):void
//		{
//			target.addEventListener(MouseEvent.MOUSE_DOWN, __onEdit);
//		}
		
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
			/*
			var target:DisplayObject = evt.currentTarget as DisplayObject;
			if(target != stage){
				control.setTarget(target);
			}else if(target == evt.target){
				control.setTarget(null);
				inspector.clearTargetInfo();
			}
			*/
		}
		
		private function saveAll():void
		{
			var xml:XML = <View/>;
			for(var i:int=0; i<editArea.numChildren; ++i){
				var child:DisplayObject = editArea.getChildAt(i);
				xml.appendChild(PropKeys.Instance.castItemToXML(child));
			}
			FileUtil.WriteString(file.resolvePath("a.xml"), xml.toXMLString());
			export();
		}
		//*
		private var file:File = new File("C:/Users/Administrator/Documents/MyMornUI/morn/pages");
		private function export():void
		{
			var fileDict:Object = {};
			var writePath:File = file.resolvePath("../release");
			
			FileIO2.Traverse(file, function(f:File):Boolean{
				var key:String = file.getRelativePath(f);
				fileDict[key] = XML(FileUtil.ReadString(f));
			});
			for(var fileName:String in fileDict){
				var clsDef:ClassDef = new ClassDef();
				clsDef.loadXML(fileName, fileDict);
				FileUtil.WriteString(writePath.resolvePath(clsDef.filePath), clsDef.toString());
			}
		}
		
		private function genFileTree(file:File):XML
		{
			var result:XML = <node/>;
			result.@label = file.name;
			if(file.isDirectory){
				for each(var f:File in file.getDirectoryListing()){
					result.appendChild(genFileTree(f));
				}
			}
			return result;
		}
		//*/
	}
}

