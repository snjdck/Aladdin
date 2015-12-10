package snjdck.g2d
{
	import flash.events.MouseEvent;
	
	import snjdck.g2d.impl.DisplayObject2D;
	import snjdck.g2d.impl.DisplayObjectContainer2D;

	internal class MouseEventDispatcher
	{
		private var prevMouseTarget:DisplayObject2D;
		private var root:DisplayObjectContainer2D;
		
		public function MouseEventDispatcher(root:DisplayObjectContainer2D)
		{
			this.root = root;
		}
		
		public function getMouseTarget():DisplayObject2D
		{
			return prevMouseTarget;
		}
		
		public function update():void
		{
			var mouseTarget:DisplayObject2D = root.findTargetUnderMouse() || root;
			
			if(mouseTarget == prevMouseTarget){
				return;
			}
			
			var shareParent:DisplayObject2D = findShareParent(mouseTarget, prevMouseTarget);
			
			notifyEvent(prevMouseTarget, MouseEvent.MOUSE_OUT, shareParent);
			notifyEvent(mouseTarget, MouseEvent.MOUSE_OVER, shareParent);
			
			prevMouseTarget = mouseTarget;
		}
		
		public function notifyEvent(target:DisplayObject2D, evtType:String, finalNode:DisplayObject2D=null):void
		{
			while(target != finalNode){
				if(target.mouseEnabled){
					target.notify(evtType, target);
				}
				target = target.parent;
			}
		}
		
		private function findShareParent(a:DisplayObject2D, b:DisplayObject2D):DisplayObject2D
		{
			while(a != null){
				var tb:DisplayObject2D = b;
				while(tb != null){
					if(a == tb){
						return a;
					}
					tb = tb.parent;
				}
				a = a.parent;
			}
			return null;
		}
	}
}