package snjdck.interpreter
{
	import snjdck.arithmetic.IScriptContext;

	final public class ExecContext implements IScriptContext
	{
		private var parent:IScriptContext;
		private var dict:Object;
		
		public function ExecContext(parent:IScriptContext)
		{
			this.parent = parent;
			this.dict = {};
		}
		
		public function getValue(key:String):*
		{
			if(key in dict){
				return dict[key];
			}else if(parent){
				return parent.getValue(key);
			}
			
			return null;
		}
		
		public function setValue(key:String, value:Object):void
		{
			dict[key] = value;
		}
		
		public function createChildContext():IScriptContext
		{
			// TODO Auto Generated method stub
			return null;
		}
		
		public function delKey(key:String):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function hasKey(key:String, searchParent:Boolean):Boolean
		{
			// TODO Auto Generated method stub
			return false;
		}
		
		public function newKey(key:String, value:Object):void
		{
			// TODO Auto Generated method stub
			
		}
		
	}
}