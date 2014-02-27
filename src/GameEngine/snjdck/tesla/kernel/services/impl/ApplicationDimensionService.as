package snjdck.tesla.kernel.services.impl
{
	import flash.display.Stage;
	import flash.events.Event;
	
	import flash.signals.ISignal;
	import flash.signals.Signal;
	import snjdck.tesla.kernel.services.IApplicationDimensionService;
	import snjdck.tesla.kernel.services.support.Service;
	
	public class ApplicationDimensionService extends Service implements IApplicationDimensionService
	{
		[Inject]
		public var stage:Stage;
		
		private var _resizeSignal:Signal = new Signal();
		
		public function ApplicationDimensionService()
		{
		}
		
		[Inject]
		public function onInit():void
		{
			stage.addEventListener(Event.RESIZE, __onResize);
		}
		
		private function __onResize(evt:Event):void
		{
			_resizeSignal.notify();
		}
		
		public function get resizeSignal():ISignal
		{
			return null;
		}
		
		public function get width():int
		{
			return stage.stageWidth;
		}
		
		public function get height():int
		{
			return stage.stageHeight;
		}
	}
}