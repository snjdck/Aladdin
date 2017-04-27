package flash.mvc
{
	import flash.ioc.IInjector;
	import flash.ioc.Injector;
	import flash.mvc.kernel.ICommand;
	import flash.mvc.kernel.INotifier;
	import flash.mvc.kernel.IView;
	import flash.mvc.notification.Msg;
	import flash.mvc.notification.MsgName;
	import flash.utils.Dictionary;
	
	import array.del;
	import array.has;
	
	public class Module implements INotifier
	{
		protected const injector:IInjector = new Injector();
		
		private const viewList:Vector.<IView> = new Vector.<IView>();
		private const commandDict:Object = new Dictionary();
		
		public function Module()
		{
			injector.mapValue(Module, this, null, false);
			injector.mapValue(IInjector, injector, null, false);
		}
		
		internal function set applicationInjector(value:IInjector):void
		{
			injector.parent = value;
		}
		
		final public function regService(serviceInterface:Class, serviceClass:Class, asLocal:Boolean=false):void
		{
			if(asLocal){
				injector.mapSingleton(serviceInterface, serviceClass);
			}else{
				injector.parent.mapSingleton(serviceInterface, serviceClass, null, injector);
			}
		}
		
		final public function notify(msgName:MsgName, msgData:Object=null):Boolean
		{
			var msg:Msg = new Msg(msgName, msgData);
			notifyViews(msg);
			execCommand(msg);
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
			if(hasView(view))
				return;
			viewList.push(view);
			injector.injectInto(view);
		}
		
		final public function delView(view:IView):void
		{
			array.del(viewList, view);
		}
		
		final public function hasView(view:IView):Boolean
		{
			return array.has(viewList, view);
		}
		
		private function notifyViews(msg:Msg):void
		{
			for each(var view:IView in viewList){
				if(msg.isProcessCanceled())
					break;
				view.handleMsg(msg);
			}
		}
		
		final public function regCmd(msgName:MsgName, command:ICommand):void
		{
			commandDict[msgName] = command;
			injector.injectInto(command);
		}
		
		final public function delCmd(msgName:MsgName):void
		{
			delete commandDict[msgName];
		}
		
		final public function hasCmd(msgName:MsgName):Boolean
		{
			return commandDict[msgName] != null;
		}
		
		private function execCommand(msg:Msg):void
		{
			if(msg.isProcessCanceled())
				return;
			var command:ICommand = commandDict[msg.name];
			if(command != null)
				command.exec(msg);
		}
		
		virtual public function initAllModels():void		{}
		virtual public function initAllServices():void		{}
		virtual public function initAllViews():void			{}
		virtual public function initAllCommands():void		{}
		virtual public function onStartup():void			{}
	}
}