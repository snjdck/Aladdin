package flash.data
{
	import flash.net.SharedObject;

	final public class LocalStorage
	{
		private var so:SharedObject;
		
		public function LocalStorage(name:String)
		{
			so = SharedObject.getLocal(name);
		}
		
		public function getValue(keyName:String):*
		{
			return so.data[keyName];
		}
		
		public function setValue(keyName:String, value:*):void
		{
			so.data[keyName] = value;
		}
		
		public function hasKey(keyName:String):Boolean
		{
			return $dict.hasKey(so.data, keyName);
		}
		
		public function delKey(keyName:String):void
		{
			$dict.deleteKey(so.data, keyName);
		}
		
		public function clear():void
		{
			so.clear();
		}
		
		public function flush():void
		{
			so.flush();
		}
	}
}