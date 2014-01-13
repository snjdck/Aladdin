package snjdck.tooltip
{
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	public class TooltipMgr
	{
		private const tipInfoDict:Object = new Dictionary(true);
		private const tooltipDict:Object = new Dictionary();
		
		private var dock:Sprite;
		
		public function TooltipMgr(dock:Sprite)
		{
			this.dock = dock;
			dock.mouseChildren = false;
		}
		
		public function reg(target:InteractiveObject, tipInfo:Object, tipType:Class):void
		{
			target.addEventListener(MouseEvent.ROLL_OVER, __onMouseOver);
			tipInfoDict[target] = new TooltipInfo(tipInfo, tipType);
		}
		
		public function unreg(target:InteractiveObject):void
		{
			if(target in tipInfoDict){
				target.removeEventListener(MouseEvent.ROLL_OVER, __onMouseOver);
				delete tipInfoDict[target];
			}
		}
		
		private function __onMouseOver(evt:MouseEvent):void
		{
			var target:InteractiveObject = evt.currentTarget as InteractiveObject;
			
			target.addEventListener(MouseEvent.MOUSE_MOVE, __onMouseMove);
			target.addEventListener(MouseEvent.ROLL_OUT, __onMouseOut);
			
			var tipInfo:TooltipInfo = tipInfoDict[target];
			tipInfo.show(dock, tooltipDict);
			
			__onMouseMove(evt);
		}
		
		private function __onMouseOut(evt:MouseEvent):void
		{
			var target:InteractiveObject = evt.currentTarget as InteractiveObject;
			
			target.removeEventListener(MouseEvent.MOUSE_MOVE, __onMouseMove);
			target.removeEventListener(MouseEvent.ROLL_OUT, __onMouseOut);
			
			var tipInfo:TooltipInfo = tipInfoDict[target];
			tipInfo.hide(tooltipDict);
		}
		
		private function __onMouseMove(evt:MouseEvent):void
		{
			var tipInfo:TooltipInfo = tipInfoDict[evt.currentTarget];
			tipInfo.move(tooltipDict, evt.stageX, evt.stageY);
		}
	}
}