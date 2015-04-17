package snjdck.gpu
{
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import flash.signals.ISignal;
	import flash.signals.Signal;
	
	import snjdck.clock.Clock;
	import snjdck.clock.ITicker;
	import snjdck.g2d.impl.DisplayObject2D;
	import snjdck.g3d.pickup.RayTestInfo;
	import snjdck.gpu.matrixstack.MatrixStack2DInv;

	final public class Input implements ITicker
	{
		public var isMouseDown:Boolean;
		public var isMouseMove:Boolean;
		
		public const mouseLocation:Vector3D = new Vector3D();
		
		public const mouseMoveSignal:Signal = new Signal();
		public const mouseDownSignal:Signal = new Signal();
		public const mouseUpSignal:Signal = new Signal();
		public const clickSignal:Signal = new Signal();
		
		private const matrixStack:MatrixStack2DInv = new MatrixStack2DInv();
		
		public function Input(stage:Stage)
		{
			stage.addEventListener(MouseEvent.MOUSE_DOWN,	__onStageEvent);
			stage.addEventListener(MouseEvent.MOUSE_UP,		__onStageEvent);
//			stage.addEventListener(MouseEvent.CLICK,		__onStageEvent);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, 	__onMouseMove);
			Clock.getInstance().add(this);
		}
		
		private function __onMouseMove(evt:MouseEvent):void
		{
			isMouseMove = true;
			mouseLocation.setTo(evt.stageX, evt.stageY, 0);
		}
		
		public function onTick(timeElapsed:int):void
		{
			if(!isMouseMove){
				return;
			}
			isMouseMove = false;
			mouseMoveSignal.notify();
		}
		
		private function __onStageEvent(evt:MouseEvent):void
		{
			mouseLocation.setTo(evt.stageX, evt.stageY, 0);
			switch(evt.type)
			{
				case MouseEvent.MOUSE_DOWN:
					isMouseDown = true;
					mouseDownSignal.notify();
					break;
				case MouseEvent.MOUSE_UP:
					isMouseDown = false;
					mouseUpSignal.notify();
					break;
				case MouseEvent.CLICK:
					clickSignal.notify();
					break;
			}
			if(!boradcast2d(evt.type)){
				boradcast3d(evt.type);
			}
		}
		
		private function boradcast2d(evtType:String):Boolean
		{
			var result:Boolean = true;
			var target:DisplayObject2D = App3D.app.view3d.scene2d.pickup(matrixStack, mouseLocation.x, mouseLocation.y);
			
			if(null == target){
				target = App3D.app.view3d.scene2d;
				result = false;
			}
			while(target != null && target.mouseEnabled){
				switch(evtType){
					case MouseEvent.MOUSE_DOWN:
						target.mouseDownSignal.notify();
						break;
					case MouseEvent.MOUSE_UP:
						target.mouseUpSignal.notify();
						break;
				}
				target = target.parent;
			}
			return result;
		}
		
		private function boradcast3d(evtType:String):void
		{
			var result:Vector.<RayTestInfo> = new Vector.<RayTestInfo>();
			var view3d:View3D = App3D.app.view3d;
			
			view3d.scene3d.pickup(view3d.screenX, view3d.screenY, result);
			if(result.length < 1){
				return;
			}
			
			result.sort(__sort);
			var info:RayTestInfo = result[0];
			
			switch(evtType){
				case MouseEvent.MOUSE_DOWN:
					info.target.mouseDownSignal.notify(info);
					break;
				case MouseEvent.MOUSE_UP:
					break;
			}
		}
		
		static private function __sort(a:RayTestInfo, b:RayTestInfo):int
		{
			var pa:Vector3D = a.globalPos;
			var pb:Vector3D = b.globalPos;
			return pa.z < pb.z ? -1 : 1;
		}
	}
}