package flash.mvc
{
	import flash.ioc.Injector;
	import flash.mvc.kernel.IController;
	import flash.mvc.kernel.IHandler;
	import flash.mvc.kernel.INotifier;
	import flash.mvc.kernel.IView;
	import flash.mvc.notification.Msg;
	import flash.mvc.notification.MsgName;
	
	import array.del;
	import array.has;
	
	public class Module implements INotifier
	{
		protected const injector:Injector = new Injector();
		
		private const handlerList:Vector.<IHandler> = new Vector.<IHandler>();
		
		public function Module()
		{
			injector.mapValue(Module, this, null, false);
			injector.mapValue(Injector, injector, null, false);
		}
		
		internal function set applicationInjector(value:Injector):void
		{
			injector.parent = value;
		}
		
		final public function regService(serviceInterface:Class, serviceClass:Class, asLocal:Boolean=false):void
		{
			var target:Injector = asLocal ? injector : injector.parent;
			target.mapSingleton(serviceInterface, serviceClass, null, injector);
		}
		
		final public function notify(msgName:Object, msgData:Object=null):Boolean
		{
			var msg:Msg = new Msg(msgName, msgData);
			for each(var handler:IHandler in handlerList){
				if(msg.isProcessCanceled())
					break;
				handler.handleMsg(msg);
			}
			return !msg.isDefaultPrevented();
		}
		
		final public function regModel(modelType:Class, model:Object):void
		{
			injector.mapValue(modelType, model);
		}
		
		final public function delModel(modelType:Class):void
		{
			injector.unmap(modelType);
		}
		
		final public function regView(view:IView):void
		{
			regHandler(view);
		}
		
		final public function delView(view:IView):void
		{
			array.del(handlerList, view);
		}
		
		final public function regController(controller:IController):void
		{
			regHandler(controller);
		}
		
		final public function delController(controller:IController):void
		{
			array.del(handlerList, controller);
		}
		
		private function regHandler(handler:IHandler):void
		{
			if(has(handlerList, handler))
				return;
			handlerList.push(handler);
			injector.injectInto(handler);
		}
		
		virtual public function initAllModels():void		{}
		virtual public function initAllServices():void		{}
		virtual public function initAllViews():void			{}
		virtual public function initAllControllers():void	{}
		virtual public function onStartup():void			{}
	}
}