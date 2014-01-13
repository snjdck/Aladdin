package snjdck.display.dnd
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	public class DragDropEvent extends Event
	{
		static public const DRAG_ENTER:String = "dragEnter";
//		static public const DRAG_OVER:String = "dragOver";
		static public const DRAG_EXIT:String = "dragExit";
		static public const DRAG_DROP:String = "dragDrop";
			
		static public const DRAG_START:String = "dragStart";
//		static public const DRAG_UPDATE:String = "dragUpdate";
		static public const DRAG_COMPLETE:String = "dragComplete";
		
		private var _dragTarget:DisplayObject;
		private var _dragData:Object;
		
		public function DragDropEvent(type:String, dragTarget:DisplayObject, dragData:Object)
		{
			super(type);
			this._dragTarget = dragTarget;
			this._dragData = dragData;
		}
		
		public function get dragTarget():DisplayObject
		{
			return _dragTarget;
		}

		public function get dragData():*
		{
			return _dragData;
		}
		
		override public function clone():Event
		{
			return new DragDropEvent(type, dragTarget, dragData);
		}
	}
}