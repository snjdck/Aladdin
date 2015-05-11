package flash.signals
{
	import dict.hasKey;

	final public class SignalGroup
	{
		private const signalDict:Object = {};
		private var paramType:Class;
		
		public function SignalGroup(paramType:Class)
		{
			this.paramType = paramType;
		}
		
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
		
		private function getSignal(evtName:String):Signal
		{
			if(!dict.hasKey(signalDict, evtName)){
				signalDict[evtName] = new Signal(paramType);
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