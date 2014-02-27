package
{
	
//	import engine.ui.components.VButton;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import ui.ComboBox;
	import ui.Frame;
	import ui.ProgressBar;
	import ui.button.Button;
	import ui.core.Container;
	import ui.list.List;
	import ui.list.ScrollList;
	import ui.scrollpane.ScrollPane;
	import ui.tabedpane.Accordion;
	import ui.tabedpane.TabNav;
	import ui.text.Label;
	import ui.text.TextArea;
	import ui.text.TextInput;
	
	[SWF(width=1280, height=800, backgroundColor=0xFFFFFF, frameRate=60)]
	public class UITest extends Sprite
	{
		public function UITest()
		{
			var dock:Container = new Container();
			addChild(dock);
			
			var label:Label = new Label();
			label.text = "i am a lab\n el";
			label.x = 300;
			dock.addChild(label);
			
			var input:TextInput = new TextInput();
			input.x = 400;
			dock.addChild(input);
			
//			var textArea:TextArea = new TextArea();
//			textArea.x = 400;
//			textArea.y = 100;
//			addChild(textArea.getDisplayObject());
			
			var btn:Button;
			
			
			btn = createBtn("test 1");
			btn.x = 100;
			btn.enabled = false;
			
			btn = createBtn("test 2");
			btn.y = 100;
			btn.toggled = true;
			btn.addEventListener(MouseEvent.CLICK, function(e:Event):void{
				var val:Array = createListData(50-(--tickCount));
				list.setValue(val);
			});
			
//			btn = new CheckBox();
			btn.label.text = "check box";
			
			var accordion:Accordion = new Accordion();
			accordion.x = 100;
			accordion.y = 200;
			accordion.addTab(createLabel("content 1"), "title1");
			accordion.addTab(new TextArea(), "title2");
			accordion.addTab(btn, "title3");
			accordion.addEventListener(Event.CHANGE, function(e:Event):void{
			
			trace(accordion.height);
			});
			dock.addChild(accordion);
			accordion.expandAll();
			accordion.collapseAll();
			
			var bar:TextArea = new TextArea();
//			var scrollPane:ScrollPane = new ScrollPane();
//			scrollPane.x = 500;
			bar.text = createListData().join("\n");
//			scrollPane.setView(bar);
			
			
			var list:ScrollList= createList();
//			list.listItemSeparaterFactory = DefaultConfig.LINE_SEPARATER;
			list.maxVisibleItems = 10;
			
			var tabNav:TabNav = new TabNav();
			tabNav.addTab(list, "title3");
			tabNav.addTab(bar, "title2");
			
			list = createList();
			var listScrollPane:ScrollPane = new ScrollPane();
			listScrollPane.width = 100;
			listScrollPane.height = 100;
			listScrollPane.addChild(list);
			tabNav.addTab(listScrollPane, "title1");
			
			btn = createBtn("this is a button!~");
			btn.addEventListener(MouseEvent.CLICK, function(e:Event):void{
				var val:Array = createListData(50-++tickCount);
				list.setValue(val);
			});
			
			
			var comboBox:ComboBox = new ComboBox();
			comboBox.x = 500
			comboBox.y = 40;
			var popupList:List = new List();
			popupList.x = 10;
			popupList.y = 40;
			popupList.setValue(["1", "2", "3"]);
			popupList.backgroundColor = 0xFF000000;
			comboBox.popupList = popupList;
			dock.addChild(comboBox);
			
			var progressBar:ProgressBar = new ProgressBar();
			progressBar.x = 700;
			dock.addChild(progressBar);
			
			var frame:Frame = new Frame();
			frame.title = "test frame!~";
			frame.x = 400;
			frame.y = 250;
			frame.addChild(tabNav);
			dock.addChild(frame);
		}
		
		private var tickCount:int;
		
		private function createList():ScrollList
		{
			var list:ScrollList = new ScrollList();
			list.setValue(createListData());
			list.addEventListener(Event.SELECT, function(e:Event):void{
				trace(list.selectedIndex, list.selectedData);
			});
			return list;
		}
		
		private function createListData(count:int=50):Array
		{
			var result:Array = [];
			for(var i:int=0; i<count; i++){
				result.push(i.toString());
			}
			return result;
		}
		
		private function createBtn(text:String):Button
		{
			var btn:Button = new Button();
			btn.label.text = text;
			addChild(btn);
			return btn;
		}
		
		private function createLabel(text:String):Label
		{
			var label:Label = new Label();
			label.text = text;
			return label;
		}
	}
}