package snjdck.ui.layout
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.IEventDispatcher;

	public class LayoutManager
	{
		static public const Instance:LayoutManager = new LayoutManager();
		
		private const updateList:Array = [];
		private const eventSource:IEventDispatcher = new Shape();
		
		public function LayoutManager()
		{
			eventSource.addEventListener(Event.EXIT_FRAME, __onUpdate);
		}
		
		private function __onUpdate(evt:Event):void
		{
			if(updateList.length <= 0){
				return;
			}
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
			updateList.push(object);
		}
	}
}