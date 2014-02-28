package snjdck.tesla
{
	import flash.display.Sprite;
	import flash.display.Stage;
	
	import flash.mvc.Application;
	import snjdck.tesla.kernel.services.IApplicationDimensionService;
	import snjdck.tesla.kernel.services.IBitmapService;
	import snjdck.tesla.kernel.services.IKeyboardService;
	import snjdck.tesla.kernel.services.INoticeService;
	import snjdck.tesla.kernel.services.IPanelService;
	import snjdck.tesla.kernel.services.IPopupService;
	import snjdck.tesla.kernel.services.ISceneService;
	import snjdck.tesla.kernel.services.impl.ApplicationDimensionService;
	import snjdck.tesla.kernel.services.impl.KeyboardService;
	import snjdck.tesla.kernel.services.impl.NoticeService;
	import snjdck.tesla.kernel.services.impl.PanelService;
	import snjdck.tesla.kernel.services.impl.PopupService;
	import snjdck.tesla.kernel.services.impl.SceneService;
	import snjdck.tesla.kernel.services.impl.bitmapservice.BitmapService;
	import flash.viewport.IViewPort;
	import flash.viewport.ViewPort;

	public class GameEngine extends Application
	{
		public function GameEngine(root:Sprite)
		{
			getInjector().mapValue(Stage, root.stage, null, false);
			getInjector().mapValue(IViewPort, new ViewPort(root.stage), null, false);
			
			regService(ISceneService, SceneService);
			regService(IPanelService, PanelService);
			regService(IPopupService, PopupService);
			regService(INoticeService, NoticeService);
			regService(IKeyboardService, KeyboardService);
			regService(IApplicationDimensionService, ApplicationDimensionService);
			regService(IBitmapService, BitmapService);
		}
	}
}