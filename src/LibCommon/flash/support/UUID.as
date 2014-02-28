package flash.support
{
	import flash.system.Capabilities;
	
	import flash.reflection.getTypeName;
	import flash.utils.getTimer;
	
	final public class UUID
	{
		static private var counter:uint = 0;
		
		static public function CreateUID():String
		{
			var uid:String = Capabilities.serverString;
			var now:Date = new Date();
			
			uid += "_" + now.getTime();
			uid += "_" + getTimer();
			uid += "_" + uint(Math.random() * uint.MAX_VALUE);
			uid += "_" + (counter++).toString();
			
			return uid;
		}
		
		static public function CreateUniqueName(target:Object):String
		{
			return getTypeName(target, true) + "_" + (counter++).toString();
		}
	}
}