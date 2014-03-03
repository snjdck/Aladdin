package snjdck.tesla.kernel.services.impl
{
	import flash.support.Layout;
	
	import flash.display.DisplayObject;
	
	import snjdck.tesla.kernel.services.IApplicationDimensionService;
	import snjdck.tesla.kernel.services.INoticeService;
	import snjdck.tesla.kernel.services.support.Service;
	import flash.viewport.IViewPort;
	import flash.viewport.IViewPortLayer;
	import flash.viewport.ViewPortLayerName;
	
	public class NoticeService extends Service implements INoticeService
	{
		[Inject]
		public var appSize:IApplicationDimensionService;
		
		private var noticeLayer:IViewPortLayer;
		
		public function NoticeService()
		{
			super();
		}
		
		[Inject]
		public function onInit(viewPort:IViewPort):void
		{
			noticeLayer = viewPort.getLayer(ViewPortLayerName.NOTICE);
		}
		
		public function showNotice(notice:DisplayObject):void
		{
			notice.alpha = 0;
			noticeLayer.addChild(notice);
			Layout.CenterDisplay(notice, appSize.width, appSize.height);
			/*
			var tweenBuilder:ITweenBuilder = new TweenBuilder();
			tweenBuilder.sequenceBegin();
			tweenBuilder.tween(notice, 500, {"alpha":1, "y":"-20"});
			tweenBuilder.tween(notice, 1000, null);
			tweenBuilder.tween(notice, 300, {"alpha":0, "y":"-10"});
			tweenBuilder.getRootTween().completeSignal.add(function():void{
				noticeLayer.removeChild(notice);
			});
			tweenBuilder.getRootTween().play();
			*/
//			TweenOp.Sequence(
//				new Tween(ui, 500, {"alpha":1, "y":"-10"}),
//				new Tween(ui, 1000),
//				new Tween(ui, 300, {"alpha":0, "y":"-4"}, null, [onTweenEnd, notice])
//			);
		}
		
//		private function onTweenEnd(notice:DisplayObject):void
//		{
//			noticeLayer.removeChild(notice);
//		}
	}
}