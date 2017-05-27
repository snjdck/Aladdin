package 
{
	import flash.display.DisplayObject;
	import flash.display.ImageControl;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileIO2;
	import flash.filesystem.FileUtil;
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
	import snjdck.editor.menu.EditItemMenu;
	import snjdck.fileformat.zip.Zip;
	
	import stdlib.constant.KeyCode;
	
	import test.Test1UI;
	import test.Test2UI;

	Test1UI;
	Test2UI;
	aUI;
	
	public class EditorTest extends Sprite
	{
		private var control:ImageControl = new ImageControl();
		private var inspector:PropInspector = new PropInspector(control);
		
		private var editArea:View = new View();
		private var inspectorArea:Sprite = new Sprite();
		
		public function EditorTest()
		{
			
			$.root = this;
			inspectorArea.addChild(inspector);
			inspectorArea.x = stage.stageWidth - 200;
			
			editArea.width = stage.stageWidth;
			editArea.height = stage.stageHeight;
			
			addChild(editArea);
			addChild(inspectorArea);
			addChild(control);
			App.init(this);
			
			Http.Get("MornUILib.swc", null, function(ok:Boolean, data:ByteArray):void{
				var zip:Object = Zip.Parse(data);
				var context:LoaderContext = new LoaderContext(false, ClassDef.domain);
				context.allowCodeImport = true;
				loadMedia(zip["library.swf"], function(ok:Boolean, _:Object):void{
					ClassDef.init();
//					init();
					addControlRect();
				}, null, context);
			});
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, __onKeyDown);
		}
		
		private function __onKeyDown(evt:KeyboardEvent):void
		{
			if(evt.keyCode == KeyCode.S && evt.controlKey){
				saveAll();
			}
		}
		
		private function loadProgress(value:Number):void {
			//加载进度
			//trace("loaded", value);
		}
		
		private function loadComplete():void {
			//实例化场景
			var btn:Button = new Button();
			new ItemData(btn);
			btn.skin = "png.comp.btn_close";
			listenEvent(btn);
			editArea.addChild(btn);
			
			var img:Image = new Image();
			new ItemData(img);
			img.skin = "png.comp.bg";
			listenEvent(img);
			editArea.addChild(img).x = 200;
			
			EditItemMenu.Instance.attach(btn);
			EditItemMenu.Instance.attach(img);
			EditItemMenu.Instance.attach(control);
			
			listenEvent(stage);
		}
		
		private function listenEvent(target:InteractiveObject):void
		{
			target.addEventListener(MouseEvent.MOUSE_DOWN, __onEdit);
		}
		
		private function __onEdit(evt:MouseEvent):void
		{
			var target:DisplayObject = evt.currentTarget as DisplayObject;
			if(target != stage){
				control.setTarget(target);
			}else if(target == evt.target){
				control.setTarget(null);
				inspector.clearTargetInfo();
			}
		}
		
		private function saveAll():void
		{
			var xml:XML = <View/>;
			for(var i:int=0; i<editArea.numChildren; ++i){
				var child:DisplayObject = editArea.getChildAt(i);
//				var typeName:String = getTypeName(child, true);
//				var node:XML = XML("<" + typeName + "/>")
				xml.appendChild(PropKeys.Instance.castItemToXML(child));
//				var keyList:Array = PropKeys.Instance.getKeys(typeName);
//				for each(var key:String in keyList){
//					setProp(node, child, key);
//				}
			}
			FileUtil.WriteString(file.resolvePath("a.xml"), xml.toXMLString());
			init();
		}
		
//		private function setProp(xml:XML, target:DisplayObject, key:String):void
//		{
//			xml.@[key] = ItemData.getKey(target, key);
//		}
		
		private function addControlRect():void
		{
			App.loader.loadAssets(["assets/comp.swf", "assets/vector.swf"], new Handler(loadComplete), new Handler(loadProgress));
		}
		//*
		private var file:File = new File("C:/Users/Administrator/Documents/MyMornUI/morn/pages");
		private function init():void
		{
			var fileDict:Object = {};
			
			var writePath:File = new File("C:/Users/Administrator/Documents/MyMornUI/morn/release");
			
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
		//*/
	}
}