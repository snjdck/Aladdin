package snjdck.mvc.imp
{
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import dict.clear;
	import dict.deleteKey;
	import dict.hasKey;
	
	import snjdck.mvc.Module;
	import snjdck.mvc.Msg;
	import snjdck.mvc.MsgName;
	import snjdck.mvc.ns_mvc;
	import snjdck.mvc.core.INotifier;
	import snjdck.mvc.helper.EventManager;
	import snjdck.mvc.helper.MsgHandlerInfo;
	import snjdck.mvc.helper.argType.ArgType;
	import snjdck.mvc.helper.argType.IArgType;
	
	use namespace ns_mvc;
	
	public class Mediator implements INotifier
	{
		protected var id:String;
		
		private const evtMgr:EventManager = new EventManager();
		private const handlerMap:Object = new Dictionary();
		protected var module:Module;
		
		ns_mvc var viewComponent:Object;
		
		public function Mediator(viewComponent:Object)
		{
			this.viewComponent = viewComponent;
		}
		
		final internal function regToModule(module:Module):void
		{
			this.module = module;
			this.onReg();
		}
		
		final internal function delFromModule():void
		{
			this.onDel();
			this.module = null;
			clear(handlerMap);
			evtMgr.delAllEvts();
		}
		
		final protected function addMsgHandler(msgName:MsgName, handler:Function, argType:IArgType=null, filterKey:String=null):void
		{
			if(!hasKey(handlerMap, msgName)){
				handlerMap[msgName] = new MsgHandlerInfo(handler, (argType || ArgType.Default), filterKey);
			}
		}
		
		final protected function removeMsgHandler(msgName:MsgName):void
		{
			deleteKey(handlerMap, msgName);
		}
		
		final ns_mvc function handleMsg(msg:Msg):void
		{
			if(!hasKey(handlerMap, msg.name)){
				return;
			}
			
			if(msg.name.isReply && this != msg.from){
				return;
			}
			
			var handlerInfo:MsgHandlerInfo = handlerMap[msg.name];
			handlerInfo.exec(msg, id);
		}
		
		final public function notify(msgName:MsgName, msgData:Object=null):Boolean
		{
			return module.notifyImp(new Msg(msgName, msgData, this));
		}
		
		final protected function addEvtHandler(target:IEventDispatcher, evtType:String, listener:Function):void
		{
			evtMgr.addEvt(target, evtType, listener);
		}
		
		final protected function removeEvtHandler(target:IEventDispatcher, evtType:String, listener:Function):void
		{
			evtMgr.delEvt(target, evtType, listener);
		}
		
		protected function onReg():void{}
		protected function onDel():void{}
	}
}