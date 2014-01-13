package snjdck.mvc
{
	import snjdck.injector.IInjector;
	import snjdck.injector.Injector;
	import snjdck.mvc.core.IApplication;
	import snjdck.mvc.core.IController;
	import snjdck.mvc.core.IModel;
	import snjdck.mvc.core.IModule;
	import snjdck.mvc.core.INotifier;
	import snjdck.mvc.core.IView;
	import snjdck.mvc.imp.Controller;
	import snjdck.mvc.imp.Mediator;
	import snjdck.mvc.imp.Model;
	import snjdck.mvc.imp.View;
	import snjdck.tesla.kernel.ui.IViewPortLayer;
	
	use namespace ns_mvc;
	
	public class Module implements IModule, INotifier, IModel, IView, IController
	{
		private var application:IApplication;
		
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
		
		final public function regService(serviceInterface:Class, serviceClass:Class, asLocal:Boolean=false):void
		{
			if(asLocal){
				injector.mapSingleton(serviceInterface, serviceClass);
			}else{
				application.regService(serviceInterface, serviceClass, injector);
			}
		}
		
		final public function bindToApplication(application:IApplication):void
		{
			this.application = application;
			injector.parent = application.getInjector();
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
		
		final public function mapView(viewCls:Class, mediatorCls:Class, layer:IViewPortLayer):void
		{
			view.mapView(viewCls, mediatorCls, layer);
		}
		
		virtual public function initAllModels():void		{}
		virtual public function initAllServices():void		{}
		virtual public function initAllViews():void			{}
		virtual public function initAllControllers():void	{}
	}
}