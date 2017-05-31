package snjdck.ui.layout
{
	import flash.events.Event;

	internal class LayoutManager
	{
		private const updateList:Array = [];
		
		public function LayoutManager()
		{
		}
		
		private function __onUpdate(evt:Event):void
		{
			$.stage.removeEventListener(Event.RENDER, __onUpdate);
			for each(var layoutObject:LayoutObject in updateList){
				if(layoutObject.stage && layoutObject.visible){
					layoutObject.reLayout();
				}
			}
			updateList.length = 0;
		}
		
		public function requestUpdate(object:LayoutObject):void
		{
			for(var i:int=updateList.length-1; i >= 0; --i){
				var layoutObject:LayoutObject = updateList[i];
				if(layoutObject.contains(object)){
					return;
				}
				if(object.contains(layoutObject)){
					updateList[i] = object;
					return;
				}
			}
			if(updateList.length <= 0){
				$.stage.addEventListener(Event.RENDER, __onUpdate);
				$.stage.invalidate();
			}
			updateList.push(object);
		}
	}
}