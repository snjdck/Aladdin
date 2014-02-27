package ui
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.DisplayUtil;
	
	import ui.button.Button;
	import ui.core.Component;
	import ui.list.IList;
	import ui.list.ScrollList;
	import ui.support.DefaultConfig;
	
	public class ComboBox extends Component
	{
		private var _mainBtn:Button;
		private var _popupBtn:Button;
		private var _popupList:IList;
		
		public function ComboBox()
		{
			popupBtn.addEventListener(MouseEvent.CLICK, __onRollOverBtnClick);
		}
		
		override protected function createChildren():void
		{
			_mainBtn = new Button();
			_popupBtn = DefaultConfig.createComboBoxPopupBtn();
			
			addChild(mainBtn);
			addChild(popupBtn);
		}
		
		override protected function initDefaultUI():void
		{
			popupBtn.x = 90;
			popupBtn.y = 3;
		}
		
		private function __onRollOverBtnClick(event:MouseEvent):void
		{
			togglePopupList();
		}
		
		private function __onListSelect():void
		{
			mainBtn.label.text = ""+popupList.selectedData;
			togglePopupList();
			dispatchEvent(new Event(Event.SELECT));
		}
		
		private function togglePopupList():void
		{
			if(null == popupList){
				return;
			}
			if(popupList.getDisplayObject().stage){
				hidePopupList();
			}else{
				showPopupList();
			}
		}
		
		private const lastPopupListXY:Point = new Point();
		
		private function showPopupList():void
		{
			lastPopupListXY.x = popupList.getDisplayObject().x;
			lastPopupListXY.y = popupList.getDisplayObject().y;
			var pos:Point = localToGlobal(lastPopupListXY);
			DisplayUtil.MoveTo(popupList.getDisplayObject(), pos.x, pos.y);
			stage.addChild(popupList.getDisplayObject());
			stage.addEventListener(MouseEvent.CLICK, __onStageClick);
		}
		
		private function hidePopupList():void
		{
			stage.removeEventListener(MouseEvent.CLICK, __onStageClick);
			stage.removeChild(popupList.getDisplayObject());
			DisplayUtil.MoveTo(popupList.getDisplayObject(), lastPopupListXY.x, lastPopupListXY.y);
		}
		
		private function __onStageClick(event:MouseEvent):void
		{
			if(!contains(event.target as DisplayObject)){
				togglePopupList();
			}
		}

		public function get mainBtn():Button
		{
			return _mainBtn;
		}

		public function get popupBtn():Button
		{
			return _popupBtn;
		}

		public function get popupList():IList
		{
			return _popupList;
		}

		public function set popupList(value:IList):void
		{
			if(popupList == value){
				return;
			}
			if(popupList){
				popupList.selectedSignal.del(__onListSelect);
			}
			_popupList = value;
			if(popupList){
				popupList.selectedSignal.add(__onListSelect);
			}
		}
	}
}