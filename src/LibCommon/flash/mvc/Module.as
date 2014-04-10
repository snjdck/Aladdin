package flash.mvc
{
	import flash.ioc.IInjector;
	import flash.ioc.Injector;
	import flash.mvc.controller.Controller;
	import flash.mvc.kernel.IController;
	import flash.mvc.kernel.IModel;
	import flash.mvc.kernel.INotifier;
	import flash.mvc.kernel.IView;
	import flash.mvc.model.Model;
	import flash.mvc.notification.Msg;
	import flash.mvc.notification.MsgName;
	import flash.mvc.view.Mediator;
	import flash.mvc.view.View;
	import flash.viewport.IViewPortLayer;
	
	use namespace ns_mvc;
	
	public class Module implements INotifier, IModel, IView, IController
	{
		private var application:Application;
		
		protected const injector:IInjector = new Injector();
		
		private const model:Model = new Model();
		private const view:View = new View();
		private const controller:Controller = new Controller();
		
		public function Module()
		{
			injector.mapValue(IInjector, injector);
			injector.mapValue(Module, this);
			
			injector.injectInto(model);
			injector.injectInto(view);
			injector.injectInto(controller);
		}
		
		final ns_mvc function onRegisted(theApplication:Application):void
		{
			assert(null == application, "module has been registed yet!");
			application = theApplication;
			injector.parent = theApplication.getInjector();
		}
		
		final public function regService(serviceInterface:Class, serviceClass:Class, asLocal:Boolean=false):void
		{
			if(asLocal){
				injector.mapSingleton(serviceInterface, serviceClass);
			}else{
				application.regService(serviceInterface, serviceClass, injector);
			}
		}
		
		final public function notify(msgName:MsgName, msgData:Object=null):Boolean
		{
			return notifyImp(new Msg(msgName, msgData, this));
		}
		
		final ns_mvc function notifyImp(msg:Msg):Boolean
		{
			view.notifyMediators(msg);
			controller.execCmds(msg);
			return !msg.isDefaultPrevented();
		}
		
		final public function regProxy(proxyCls:Class):void
		{
			model.regProxy(proxyCls);
		}
		
		final public function delProxy(proxyCls:Class):void
		{
			model.delProxy(proxyCls);
		}
		
		final public function hasProxy(proxyCls:Class):Boolean
		{
			return model.hasProxy(proxyCls);
		}
		
		final public function regMediator(mediator:Mediator):void
		{
			view.regMediator(mediator);
		}
		
		final public function delMediator(mediator:Mediator):void
		{
			view.delMediator(mediator);
		}
		
		final public function hasMediator(mediator:Mediator):Boolean
		{
			return view.hasMediator(mediator);
		}
		
		final public function mapViewToMediated(viewClsOrName:Object, mediatorCls:Class):void
		{
			view.mapViewToMediated(viewClsOrName, mediatorCls);
		}
		
		final public function regMediatorByView(viewTarget:Object):void
		{
			view.regMediatorByView(viewTarget);
		}
		
		final public function regCmd(msgName:MsgName, cmdCls:Class):void
		{
			controller.regCmd(msgName, cmdCls);
		}
		
		final public function delCmd(msgName:MsgName, cmdCls:Class):void
		{
			controller.delCmd(msgName, cmdCls);
		}
		
		final public function hasCmd(msgName:MsgName, cmdCls:Class):Boolean
		{
			return controller.hasCmd(msgName, cmdCls);
		}
		
		final public function execCmd(cmdCls:Class):void
		{
			controller.execCmd(cmdCls);
		}
		
		final public function mapView(viewCls:Class, mediatorCls:Class):void
		{
			view.mapView(viewCls, mediatorCls);
		}
		
		virtual public function initAllModels():void		{}
		virtual public function initAllServices():void		{}
		virtual public function initAllViews():void			{}
		virtual public function initAllControllers():void	{}
		virtual public function onStartup():void			{}
	}
}