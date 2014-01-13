package snjdck.arithmetic
{
	final public class ReturnError extends Error
	{
		private var _value:Object;
		
		public function ReturnError(value:Object)
		{
			this._value = value;
		}
		
		public function get value():*
		{
			return _value;
		}
	}
}