package flash.mvc.notification
{
	public class Msg
	{
		private var _name:MsgName;
		private var _data:Object;
		
		public function Msg(name:MsgName, data:Object)
		{
			this._name = name;
			this._data = data;
		}
		
		public function get name():MsgName
		{
			return _name;
		}
		
		public function get data():*
		{
			return _data;
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