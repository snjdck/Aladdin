package snjdck.tesla.kernel.services.impl
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import snjdck.tesla.kernel.services.IApplicationDimensionService;
	import snjdck.tesla.kernel.services.IPopupService;
	import snjdck.tesla.kernel.services.support.Service;
	import flash.viewport.IViewPort;
	import flash.viewport.IViewPortLayer;
	import flash.viewport.ViewPortLayerName;
	
	import flash.factory.newSprite;
	
	public class PopupService extends Service implements IPopupService
	{
		[Inject]
		public var stage:Stage;
		
		[Inject]
		public var appDimensionService:IApplicationDimensionService;
		
		private var panelLayer:IViewPortLayer;
		
		private var modalDialogLayer:IViewPortLayer;
		private var modalDialogMask:Sprite;
		
		public function PopupService()
		{
		}
		
		[Inject]
		public function onInit(viewPort:IViewPort):void
		{
			panelLayer = viewPort.getLayer(ViewPortLayerName.PANEL);
			modalDialogLayer = viewPort.getLayer(ViewPortLayerName.POPUP);
			
			modalDialogMask = newSprite();
			modalDialogMask.visible = false;
			modalDialogLayer.addChild(modalDialogMask);
		}
		
		public function showPopup(popup:DisplayObjectContainer):Function
		{
			const layer:IViewPortLayer = modalDialogLayer;
			layer.addChild(popup);
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN,  __onEvent, true);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, __onEvent);
			
			function closeHandler():void
			{
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, __onEvent, true);
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, __onEvent);
				layer.removeChild(popup);
			}
			
			function __onEvent(event:Event):void
			{
				if(popup.contains(event.target as DisplayObject)){
					return;
				}
				closeHandler();
			}
			
			return closeHandler;
		}
		
		private function redrawModalDialogMask():void
		{
			var maskWidth:int = appDimensionService.width;
			var maskHeight:int = appDimensionService.height;
			
			var g:Graphics = modalDialogMask.graphics;
			g.clear();
			g.beginFill(0, 0.2);
			g.drawRect(0, 0, maskWidth, maskHeight);
			g.endFill();
		}
		
		public function addPopUp(popup:DisplayObject, modal:Boolean):void
		{
			if(modal){//模态对话框
				if(hasModalDialogInShow()){
					swapModalDialogMaskIndex();
				}else{
					redrawModalDialogMask();
					modalDialogMask.visible = true;
				}
				
				modalDialogLayer.addChild(popup);
			}else{//普通面板
				panelLayer.addChild(popup);
			}
		}
		public function removePopUp(popup:DisplayObject):void
		{
			if(panelLayer.contains(popup)){
				panelLayer.removeChild(popup);
				return;
			}
			if(modalDialogLayer.contains(popup)){
				modalDialogLayer.removeChild(popup);
				
				if(isModalDialogMaskTopMost()){
					if(hasModalDialogInShow()){
						swapModalDialogMaskIndex();
					}else{
						modalDialogMask.visible = false;
					}
				}
			} 
		}
		
		private function hasModalDialogInShow():Boolean
		{
			return modalDialogLayer.numChildren > 1;
		}
		
		private function isModalDialogMaskTopMost():Boolean
		{
			return modalDialogLayer.getChildIndex(modalDialogMask) == modalDialogLayer.numChildren - 1;
		}
		
		private function swapModalDialogMaskIndex():void
		{
			var topIndex:int = modalDialogLayer.numChildren - 1;
			modalDialogLayer.swapChildrenAt(topIndex-1, topIndex);
		}
	}
}