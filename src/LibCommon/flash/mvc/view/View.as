package flash.mvc.view
{
	import flash.ioc.IInjector;
	import flash.mvc.Module;
	import flash.mvc.ns_mvc;
	import flash.mvc.kernel.IView;
	import flash.mvc.notification.Msg;
	import flash.reflection.getTypeName;
	import flash.utils.Dictionary;
	
	import dict.deleteKey;
	import dict.hasValue;
	
	use namespace ns_mvc;

	final public class View implements IView
	{
		[Inject]
		public var module:Module;
		
		[Inject]
		public var injector:IInjector;
		
		private const mediatorRefs:Object = new Dictionary();
		
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
				}
				mediator.handleMsg(msg);
			}
		}
		
		public function mapView(viewComponent:Object, mediatorCls:Class):void
		{
			if(null == viewComponent.name){
				viewComponent.name = getTypeName(viewComponent, true);
			}
			injector.injectInto(viewComponent);
			var mediator:Mediator = new mediatorCls(viewComponent);
			injector.injectInto(mediator);
			regMediator(mediator);
		}
	}
}