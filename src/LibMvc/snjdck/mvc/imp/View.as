package snjdck.mvc.imp
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import dict.deleteKey;
	import dict.hasKey;
	import dict.hasValue;
	
	import flash.ioc.IInjector;
	import snjdck.mvc.Module;
	import snjdck.mvc.Msg;
	import snjdck.mvc.ns_mvc;
	import snjdck.mvc.core.IView;
	import snjdck.tesla.kernel.ui.IViewPortLayer;
	
	import flash.reflection.getTypeName;
	import stdlib.typecast.castClsRefOrClsNameToString;
	
	use namespace ns_mvc;

	public class View implements IView
	{
		[Inject]
		public var module:Module;
		
		[Inject]
		public var injector:IInjector;
		
		private const mediatorRefs:Object = new Dictionary();
		private const viewMapToMediated:Object = {};
		
		public function View()
		{
		}
		
		public function regMediator(mediator:Mediator):void
		{
			if(!hasMediator(mediator)){
				mediatorRefs[mediator.viewComponent] = mediator;
				mediator.regToModule(module);
			}
		}
		
		public function delMediator(mediator:Mediator):void
		{
			if(hasMediator(mediator)){
				deleteKey(mediatorRefs, mediator.viewComponent);
				mediator.delFromModule();
			}
		}
		
		public function hasMediator(mediator:Mediator):Boolean
		{
			return hasValue(mediatorRefs, mediator);
		}
		
		ns_mvc function notifyMediators(msg:Msg):void
		{
			for each(var mediator:Mediator in mediatorRefs){
				if(msg.isProcessCanceled()){
					break;
				}else{
					mediator.handleMsg(msg);
				}
			}
		}
		
		public function mapViewToMediated(viewClsOrName:Object, mediatorCls:Class):void
		{
			var viewTypeName:String = castClsRefOrClsNameToString(viewClsOrName);
			viewMapToMediated[viewTypeName] = mediatorCls;
		}
		
		public function regMediatorByView(viewTarget:Object):void
		{
			const viewTypeName:String = getViewTargetTypeName(viewTarget);
			if(!hasKey(mediatorRefs, viewTarget) && hasKey(viewMapToMediated, viewTypeName))
			{
				var mediatorCls:Class = viewMapToMediated[viewTypeName];
				var mediator:Mediator = new mediatorCls(viewTarget);
				injector.injectInto(mediator);
				regMediator(mediator);
			}
		}
		
		public function mapView(viewCls:Class, mediatorCls:Class, layer:IViewPortLayer):void
		{
			var view:DisplayObject = new viewCls();
			layer.addChild(view);
			var mediator:Mediator = new mediatorCls(view);
			injector.injectInto(mediator);
			regMediator(mediator);
		}
		
		private function getViewTargetTypeName(viewTarget:Object):String
		{
			if(viewTarget is DisplayObject){
				if(viewTarget is Sprite){
					return getTypeName(viewTarget);
				}
			}else if(viewTarget.hasOwnProperty("typeName")){
				return viewTarget.typeName;
			}
			return null;
		}
	}
}