package snjdck.mvc
{
	import snjdck.mvc.core.INotifier;
	
	use namespace ns_mvc;

	final public class Msg
	{
		private var _name:MsgName;
		private var _data:Object;
		
		ns_mvc var from:INotifier;
		
		public function Msg(name:MsgName, data:Object, from:INotifier)
		{
			this._name = name;
			this._data = data;
			this.from = from;
		}
		
		public function get name():MsgName
		{
			return _name;
		}
		
		public function get data():*
		{
			return _data;
		}
		
		public function reply(msgData:Object=null):void
		{
			from.notify(name.REPLY, msgData);
		}
		
		/** cancelProcess */
		private var processCanceledFlag:Boolean;
		
		public function cancelProcess():void
		{
			processCanceledFlag = true;
		}
		
		public function isProcessCanceled():Boolean
		{
			return processCanceledFlag;
		}
		
		/** preventDefault */
		private var defaultPreventedFlag:Boolean;
		
		public function preventDefault():void
		{
			defaultPreventedFlag = true;
		}
		
		public function isDefaultPrevented():Boolean
		{
			return defaultPreventedFlag;
		}
	}
}