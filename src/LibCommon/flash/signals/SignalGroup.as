package flash.signals
{
	import dict.hasKey;

	public class SignalGroup
	{
		private const signalDict:Object = {};
		
		public function SignalGroup(){}
		
		public function addListener(evtName:String, handler:Function, once:Boolean=false):void
		{
			getSignal(evtName).add(handler, once);
		}
		
		public function removeListener(evtName:String, handler:Function):void
		{
			if(dict.hasKey(signalDict, evtName)){
				getSignal(evtName).del(handler);
			}
		}
		
		public function hasListener(evtName:String, handler:Function):Boolean
		{
			if(dict.hasKey(signalDict, evtName)){
				return getSignal(evtName).has(handler);
			}
			return false;
		}
		
		public function getSignal(evtName:String):Signal
		{
			if(!dict.hasKey(signalDict, evtName)){
				signalDict[evtName] = new Signal(Object);
			}
			return signalDict[evtName];
		}
		
		public function notify(evtName:String, arg:Object):void
		{
			if(dict.hasKey(signalDict, evtName)){
				getSignal(evtName).notify(arg);
			}
		}
	}
}