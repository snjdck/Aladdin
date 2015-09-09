package flash.udp
{
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.net.GroupSpecifier;
	import flash.net.NetConnection;
	import flash.net.NetGroup;
	
	[Event(name="init", type="flash.udp.LocalGroupEvent")]
	[Event(name="connect", type="flash.udp.LocalGroupEvent")]
	[Event(name="disconnect", type="flash.udp.LocalGroupEvent")]
	[Event(name="message", type="flash.udp.LocalGroupEvent")]
	
	/** 局域网,本地组 */
	public class LocalGroup extends EventDispatcher
	{
		/** "myg/gone", "224.0.0.254", 30000 */
		static public function createGroupSpecifier(name:String, address:String, port:int):String
		{
			var gs:GroupSpecifier = new GroupSpecifier(name);
			gs.ipMulticastMemberUpdatesEnabled = true;
			gs.objectReplicationEnabled = true;
			gs.routingEnabled = true;
			gs.addIPMulticastAddress(address, port);
			return gs.groupspecWithAuthorizations();
		}
		
		private var nc:NetConnection;
		private var ng:NetGroup;
		private var groupSpec:String;
		
		private const handlerDict:Object = {};
		
		public function LocalGroup(groupSpec:String)
		{
			this.groupSpec = groupSpec;
			
			addHandler("NetConnection.Connect.NetworkChange",	null);
			addHandler("NetConnection.Connect.Success",	initNetGroup);
			addHandler("NetGroup.Connect.Rejected",		null);
			addHandler("NetGroup.Connect.Failed",		null);
			addHandler("NetGroup.Connect.Success",		onInit);
			addHandler("NetGroup.Neighbor.Connect",		onPeerConnect);
			addHandler("NetGroup.Neighbor.Disconnect",	onPeerDisconnect);
			addHandler("NetGroup.Posting.Notify",		onPeerMsgRecv);
			addHandler("NetGroup.SendTo.Notify",		onPeerMsgRecv);
			
			nc = new NetConnection();
			nc.addEventListener(NetStatusEvent.NET_STATUS, __onNetStatus);
			nc.connect("rtmfp:");
		}
		
		public function sendToAll(msg:Object):void
		{
			ng.sendToAllNeighbors(msg);
		}
		
		public function sendTo(msg:Object, address:String):void
		{
			ng.sendToNearest(msg, address);
		}
		
		public function close():void
		{
			ng.close();
			nc.close();
		}
		
		private function addHandler(infoCode:String, handler:Function):void
		{
			handlerDict[infoCode] = handler;
		}
		
		private function __onNetStatus(evt:NetStatusEvent):void
		{
			var info:Object = evt.info;
			var handler:Function = handlerDict[info.code];
			if(null != handler){
				handler(info);
			}
		}
		
		private function initNetGroup(info:Object):void
		{
			ng = new NetGroup(nc, groupSpec);
			ng.addEventListener(NetStatusEvent.NET_STATUS, __onNetStatus);
		}
		
		private function onInit(info:Object):void
		{
			dispatchEvent(new LocalGroupEvent(LocalGroupEvent.INIT));
		}
		
		private function onPeerMsgRecv(info:Object):void
		{
			dispatchEvent(new LocalGroupEvent(LocalGroupEvent.MESSAGE, info.from, info.message));
		}
		
		private function onPeerConnect(info:Object):void
		{
			dispatchEvent(new LocalGroupEvent(LocalGroupEvent.CONNECT, info.neighbor));
		}
		
		private function onPeerDisconnect(info:Object):void
		{
			dispatchEvent(new LocalGroupEvent(LocalGroupEvent.DISCONNECT, info.neighbor));
		}
	}
}