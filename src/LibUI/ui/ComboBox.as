package ui
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.DisplayUtil;
	
	import ui.list.IList;
	import ui.support.DefaultConfig;
	
	public class ComboBox extends Sprite
	{
		private var _mainBtn:Sprite;
		private var _popupBtn:Sprite;
		private var _popupList:IList;
		
		public function ComboBox()
		{
			popupBtn.addEventListener(MouseEvent.CLICK, __onRollOverBtnClick);
		}
		
		protected function createChildren():void
		{
			_mainBtn = new Sprite();
//			_popupBtn = DefaultConfig.createComboBoxPopupBtn();
			
			addChild(mainBtn);
			addChild(popupBtn);
		}
		
		protected function initDefaultUI():void
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
//			mainBtn.label.text = ""+popupList.selectedData;
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

		public function get mainBtn():Sprite
		{
			return _mainBtn;
		}

		public function get popupBtn():Sprite
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