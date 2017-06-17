package 
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.ImageControl;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileIO2;
	import flash.filesystem.FileUtil;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.http.loadMedia;
	import flash.support.Http;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import morn.core.components.View;
	
	import snjdck.editor.DragMgr;
	import snjdck.editor.FunctionButtonView;
	import snjdck.editor.TargetArranger;
	import snjdck.editor.codegen.ClassDef;
	import snjdck.editor.codegen.ClassFactory;
	import snjdck.editor.codegen.ItemData;
	import snjdck.editor.codegen.PropInspector;
	import snjdck.editor.codegen.PropKeys;
	import snjdck.editor.control.ControlList;
	import snjdck.editor.menu.EditItemMenu;
	import snjdck.editor.preview.ItemPreview;
	import snjdck.editor.selection.SelectionLayer;
	import snjdck.fileformat.zip.Zip;
	import snjdck.ui.tree.Tree;
	
	import stdlib.constant.KeyCode;
	
	[SWF(width="1000", height="600")]
	public class EditorTest extends Sprite
	{
		static public var alignToStageFlag:Boolean;
		
		private var editArea:View = new View();
		private var control:ImageControl = new ImageControl();
		private var inspector:PropInspector = new PropInspector(control);
		private var controlList:ControlList = new ControlList();
		
//		private var inspectorArea:Sprite = new Sprite();
		private var funcBtnView:FunctionButtonView = new FunctionButtonView();
		
		
		
		private var fileTree:Tree = new Tree();
		private var preview:ItemPreview = new ItemPreview();
		private var selectionLayer:SelectionLayer = new SelectionLayer(control);
		
		private var currentFilePath:String;
		private var currentViewWidth:Number;
		private var currentViewHeight:Number;
		
		public function EditorTest()
		{
			
			
			$.root = this;
//			inspectorArea.addChild(inspector);
//			inspectorArea.x = stage.stageWidth - 200;
			
			editArea.width = stage.stageWidth;
			editArea.height = stage.stageHeight;
			
			fileTree.y = 300;
			fileTree.dataProvider = genFileTree(rootFile);
			fileTree.clickSignal.add(__onShowCustomViewPreview);
			fileTree.doubleClickSignal.add(__onEditCustomView);
			fileTree.dragSignal.add(__onAddCustomView);
			
			controlList.dragSignal.add(__onAddSystemControl);
			controlList.clickSignal.add(__onShowSystemControlPreview);
			
			control.addEventListener(KeyboardEvent.KEY_DOWN, __onEditTarget);
			funcBtnView.clickSignal.add(__onFuncBtn);
			
			addChild(editArea);
			addChild(controlList);
			addChild(fileTree);
			addChild(inspector);
			addChild(preview);
			addChild(control);
			addChild(selectionLayer);
			addChild(funcBtnView);
			App.init(this);
			
			preview.right = 0;
			preview.bottom = 0;
			
			inspector.right = 0;
			inspector.top = 0;
			inspector.bottom = 200;
			
			Http.Get("MornUILib.swc", null, function(ok:Boolean, data:ByteArray):void{
				var zip:Object = Zip.Parse(data);
				var context:LoaderContext = new LoaderContext(false, ClassDef.domain);
				context.allowCodeImport = true;
				loadMedia(zip["library.swf"], function():void{
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
		
		private function __onFuncBtn(key:String):void
		{
			var targetList:Array = selectionLayer.getTargetList();
			if(control.getTarget()){
				targetList.push(control.getTarget());
			}
			var arranger:TargetArranger = new TargetArranger(targetList, currentViewWidth, currentViewHeight);
			switch(key){
				case "align left":
					arranger.alignLeft(alignToStageFlag);
					trace(key);
					break;
			}
		}
		
		private function drawEditAreaBG():void
		{
			var marginLeft:int = 100;
			var marginRight:int = 200;
			
			editArea.x = marginLeft + 0.5 * (stage.stageWidth - marginLeft - marginRight - currentViewWidth);
			editArea.y = 0.5 * (stage.stageHeight - currentViewHeight);
			
			control.x = editArea.x;
			control.y = editArea.y;
			
			var g:Graphics = editArea.graphics;
			g.clear();
//			g.beginFill(0xCCCCCC);
//			g.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
//			g.endFill();
			g.beginFill(0x999999);
			g.drawRect(0, 0, currentViewWidth, currentViewHeight);
			g.endFill();
		}
		
		private function __onEditTarget(evt:KeyboardEvent):void
		{
			if(evt.keyCode == KeyCode.DELETE){
				editArea.removeChild(control.getTarget());
				control.setTarget(null);
			}
		}
		
		private function createItemByFilePath(path:String):Sprite
		{
			var fileDict:Object = genFileDict();
			var item:Sprite = ClassFactory.Instance.create(fileDict[path], fileDict);
			ClassFactory.setViewSource(item, path);
			return item;
		}
		
		private function __onAddCustomView(xml:XML):void
		{
			if(null == currentFilePath){
				return;
			}
			addComponentToEditArea(createItemByFilePath(xml.@data));
		}
		
		private function __onAddSystemControl(config:XML):void
		{
			if(null == currentFilePath){
				return;
			}
			var view:Sprite = ClassFactory.Instance.create(config, null);
			addComponentToEditArea(view);
		}
		
		private function __onShowSystemControlPreview(config:XML):void
		{
			var view:Sprite = ClassFactory.Instance.create(config, null);
			preview.showPreview(view);
		}
		
		private function __onShowCustomViewPreview(config:XML):void
		{
			preview.showPreview(createItemByFilePath(config.@data));
		}
		
		private function addComponentToEditArea(view:Sprite):void
		{
			view.filters = [new DropShadowFilter()];
			view.x = stage.mouseX - view.width * 0.5;
			view.y = stage.mouseY - view.height * 0.5;
			DragMgr.Instance.doDrag(view, __onStopDrag);
		}
		
		private function __onStopDrag(dragItem:Sprite, evt:MouseEvent):void
		{
			if(dragItem.dropTarget == null || editArea.contains(dragItem.dropTarget as DisplayObject) || control.contains(dragItem.dropTarget)){
				dragItem.filters = [];
				addControlToEditArea(dragItem);
			}else{
				trace("del", dragItem.dropTarget, evt.target);
			}
		}
		
		private function __onEditCustomView(xml:XML):void
		{
			trace("double click", xml.@data);
			
			currentFilePath = xml.@data;
			var fileDict:Object = genFileDict();
			var config:XML = fileDict[xml.@data];
			currentViewWidth = parseFloat(config.@width);
			currentViewHeight = parseFloat(config.@height);
			var item:Sprite = ClassFactory.Instance.create(config, fileDict);
			editArea.parent.addChildAt(item, 0);
			editArea.parent.removeChild(editArea);
			editArea = item as View;
			for(var i:int=0; i<editArea.numChildren; ++i){
				item = editArea.getChildAt(i) as Sprite;
				new ItemData(item);
				EditItemMenu.Instance.attach(item);
			}
			drawEditAreaBG();
		}
		
		private function __onKeyDown(evt:KeyboardEvent):void
		{
			if(!evt.controlKey){
				return;
			}
			switch(evt.keyCode){
				case KeyCode.S:
					saveAll();
					break;
				case KeyCode.E:
					export();
					break;
			}
		}
		
		private function addControlToEditArea(item:Sprite):void
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
			if(evt.target == stage || evt.target == editArea){
				control.setTarget(null);
				inspector.clearTargetInfo();
				selectionLayer.clearAll();
				return;
			}
			if(!editArea.contains(evt.target as DisplayObject)){
				return;
			}
			var target:Sprite = findEvtTarget(evt);
			if(evt.shiftKey){//多选模式
				if(control.getTarget() == target){
					control.setTarget(null);
				}else{
					selectionLayer.toggleSelection(target);
					if(control.getTarget()){
						selectionLayer.toggleSelection(control.getTarget());
						control.setTarget(null);
					}
				}
			}else{
				control.setTarget(target);
			}
		}
		
		private function findEvtTarget(evt:MouseEvent):Sprite
		{
			for(var i:int=editArea.numChildren-1; i>=0; --i){
				var child:Sprite = editArea.getChildAt(i) as Sprite;
				if(child.contains(evt.target as DisplayObject)){
					return child;
				}
			}
			return null;
		}
		
		private function saveAll():void
		{
			if(currentFilePath == null){
				return;
			}
			var xml:XML = <View/>;
			xml.@width  = currentViewWidth;
			xml.@height = currentViewHeight;
			for(var i:int=0; i<editArea.numChildren; ++i){
				var child:DisplayObject = editArea.getChildAt(i);
				xml.appendChild(PropKeys.Instance.castItemToXML(child));
			}
			FileUtil.WriteString(rootFile.resolvePath(currentFilePath), xml.toXMLString());
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

