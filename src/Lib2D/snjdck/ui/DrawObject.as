package snjdck.ui
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class DrawObject extends Sprite
	{
		private var invalidateFlag:Boolean;
		
		public function DrawObject()
		{
			addEventListener(Event.ADDED_TO_STAGE, __onAddToStage);
		}
		
		private function __onAddToStage(evt:Event):void
		{
			trace(evt.target);
			removeEventListener(Event.ADDED_TO_STAGE, __onAddToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, __onRemoveFromStage);
			onDraw();
		}
		
		private function __onRemoveFromStage(evt:Event):void
		{
			trace(evt.target);
			removeEventListener(Event.REMOVED_FROM_STAGE, __onRemoveFromStage);
			addEventListener(Event.ADDED_TO_STAGE, __onAddToStage);
		}
		
		private function __onInvalidate(evt:Event):void
		{
			invalidateFlag = false;
			stage.removeEventListener(Event.RENDER, __onInvalidate);
			onDraw();
		}
		
		protected function invalidate():void
		{
			if(stage != null && !invalidateFlag){
				invalidateFlag = true;
				stage.addEventListener(Event.RENDER, __onInvalidate);
				stage.invalidate();
			}
		}
		
		protected function onDraw():void
		{
			
		}
	}
}