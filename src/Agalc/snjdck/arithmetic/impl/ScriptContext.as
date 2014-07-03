package snjdck.arithmetic.impl
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	import snjdck.arithmetic.IScriptContext;
	
	final internal class ScriptContext extends Proxy implements IScriptContext
	{
		private const dataDict:Object = {};
		private var parent:IScriptContext;
		
		public function ScriptContext(parent:IScriptContext=null)
		{
			this.parent = parent;
		}
		
		public function getValue(key:String):*
		{
			if(hasKey(key, false)){
				return dataDict[key];
			}
			if(parent){
				return parent.getValue(key);
			}
			trace("warning:property:'" + key + "' has not defined!");
		}
		
		public function setValue(key:String, value:Object):void
		{
			if(hasKey(key, false)){
				dataDict[key] = value;
			}else if(hasKey(key, true)){
				parent.setValue(key, value);
			}else{
				throw new ArgumentError("has no key:" + key);
			}
		}
		
		public function hasKey(key:String, searchParent:Boolean):Boolean
		{
			var result:Boolean = dataDict.hasOwnProperty(key);
			if(result){
				return true;
			}
			if(searchParent && parent){
				return parent.hasKey(key, true);
			}
			return false;
		}
		
		public function newKey(key:String, value:Object):void
		{
			dataDict[key] = value;
		}
		
		public function delKey(key:String):void
		{
			delete dataDict[key];
		}
		
		public function createChildContext():IScriptContext
		{
			return new ScriptContext(this);
		}
	}
}