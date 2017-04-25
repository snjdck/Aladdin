package flash.mvc.view
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.ioc.IInjector;
	import flash.mvc.Module;
	import flash.mvc.ns_mvc;
	import flash.mvc.kernel.IMediator;
	import flash.mvc.kernel.IView;
	import flash.mvc.notification.Msg;
	import flash.utils.DisplayUtil;
	
	import array.del;
	import array.has;
	
	use namespace ns_mvc;

	final public class View implements IView
	{
		[Inject]
		public var module:Module;
		
		[Inject]
		public var injector:IInjector;
		
		private const mediatorList:Vector.<IMediator> = new Vector.<IMediator>();
		
		public function View()
		{
		}
		
		public function regMediator(mediator:IMediator):void
		{
			if(hasMediator(mediator)){
				return;
			}
			mediatorList.push(mediator);
			DisplayUtil.Traverse(mediator as DisplayObject, __onTraverse);
		}
		
		private function __onTraverse(target:DisplayObject):void
		{
			if(target is IMediator){
				injector.injectInto(target);
			}
		}
		
		public function delMediator(mediator:IMediator):void
		{
			array.del(mediatorList, mediator);
		}
		
		public function hasMediator(mediator:IMediator):Boolean
		{
			return array.has(mediatorList, mediator);
		}
		
		ns_mvc function notifyMediators(msg:Msg):void
		{
			for each(var mediator:IMediator in mediatorList){
				if(msg.isProcessCanceled()){
					break;
				}
				Traverse(mediator as DisplayObject, msg);
			}
		}
		
		static private function Traverse(target:DisplayObject, msg:Msg):void
		{
			var container:DisplayObjectContainer = target as DisplayObjectContainer;
			var mediator:IMediator = target as IMediator;
			if(mediator != null){
				mediator.handleMsg(msg);
			}
			if(container == null){
				return;
			}
			for(var i:int=0, n:int=container.numChildren; i<n; ++i){
				Traverse(container.getChildAt(i), msg);
			}
		}
	}
}