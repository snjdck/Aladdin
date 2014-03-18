package snjdck.tesla.kernel.services.impl
{
	import array.del;
	
	import flash.display.Stage;
	import flash.signals.ISignal;
	import flash.signals.Signal;
	import flash.viewport.IViewPort;
	import flash.viewport.IViewPortLayer;
	import flash.viewport.ViewPortLayerName;
	
	import snjdck.effect.tween.Tween;
	import snjdck.tesla.core.IPanel;
	import snjdck.tesla.core.PanelShowPolicy;
	import snjdck.tesla.kernel.services.IPanelService;
	import snjdck.tesla.kernel.services.ISceneService;
	import snjdck.tesla.kernel.services.support.Service;

	public class PanelService extends Service implements IPanelService
	{
		[Inject]
		public var sceneService:ISceneService;
		
		[Inject]
		public var viewport:IViewPort;
		
		[Inject]
		public var stage:Stage;
		
		private const _panelShownSignal:Signal = new Signal(IPanel);
		private const _panelHiddenSignal:Signal = new Signal(IPanel);
		
		private const panelList:Vector.<IPanel> = new Vector.<IPanel>();
		private const shownPanels:Vector.<IPanel> = new Vector.<IPanel>();
		
		public function PanelService()
		{
		}
		
		private function showPanel_a(panel:IPanel):void
		{
			addSceneLeaveCallback(panel, function(sceneName:String):void{
				panel.hide();
			});
		}
		
		private function showPanel_b(panel:IPanel):void
		{
			const currentSceneName:String = sceneService.currentSceneName;
			
			function onEnterScene(sceneName:String):void{
				if(currentSceneName != sceneName){
					return;
				}
				sceneService.enterSceneSignal.del(onEnterScene);
				panel.show();
				addSceneLeaveCallback(panel, onLeaveScene);
			}
			
			function onLeaveScene(sceneName:String):void{
				panel.hide();
				sceneService.enterSceneSignal.add(onEnterScene);
			}
			
			addSceneLeaveCallback(panel, onLeaveScene);
		}
		
		private function addSceneLeaveCallback(panel:IPanel, onLeaveScene:Function):void
		{
			//离开场景的时候关闭面板
			sceneService.leaveSceneSignal.add(onLeaveScene, true);
			
			//关闭面板的时候移除场景事件监听
			panel.hideSignal.add(function():void{
				sceneService.leaveSceneSignal.del(onLeaveScene);
			}, true);
		}
		
		public function panelHiddenSignal():ISignal
		{
			return _panelHiddenSignal;
		}
		
		public function panelShownSignal():ISignal
		{
			return _panelShownSignal;
		}
		
		public function register(panel:IPanel):void
		{
			panel.showSignal.add(function():void{
				_panelShownSignal.notify(panel);
				__onPanelShown(panel);
			});
			panel.hideSignal.add(function():void{
				_panelHiddenSignal.notify(panel);
				__onPanelHidden(panel);
			});
			
			var layer:IViewPortLayer = viewport.getLayer(panel.isModal ? ViewPortLayerName.POPUP : ViewPortLayerName.PANEL);
			layer.addChild(panel.getDisplayObject());
			
			panelList.push(panel);
		}
		
		private function __onPanelShown(panel:IPanel):void
		{
			var panelIndex:int = Math.ceil(0.5 * shownPanels.length);
			shownPanels.splice(panelIndex, 0, panel);
			
			switch(panel.showPolicy)
			{
				case PanelShowPolicy.ALWAYS:
					break;
				case PanelShowPolicy.CLOSE_WHEN_LEAVE_SCENE:
					showPanel_a(panel);
					break;
				case PanelShowPolicy.SHOW_IN_CERTAIN_SCENE:
					showPanel_b(panel);
					break;
			}
			
			if(!panel.isModal && panel.autoArrange){
				arrangeShownPanels();
			}
		}
		
		private function __onPanelHidden(panel:IPanel):void
		{
			array.del(shownPanels, panel);
			if(!panel.isModal && panel.autoArrange){
				arrangeShownPanels();
			}
		}
		
		private function arrangeShownPanels():void
		{
			var offsetX:Number = 0.5 * (stage.stageWidth - getTotalWidth());
			for each(var panel:IPanel in shownPanels){
				new Tween(panel.getDisplayObject(), 600, {
					"x":offsetX
				}).start();
				offsetX += panel.getDisplayObject().width;
			}
		}
		
		private function getTotalWidth():Number
		{
			var totalWidth:Number = 0;
			for each(var panel:IPanel in shownPanels){
				totalWidth += panel.getDisplayObject().width;
			}
			return totalWidth;
		}
	}
}