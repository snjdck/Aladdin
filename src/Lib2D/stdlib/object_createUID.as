package stdlib
{
	import flash.system.Capabilities;
	import flash.utils.getTimer;

	public function object_createUID():String
	{
		var uid:String = Capabilities.serverString;
		var now:Date = new Date();
		
		uid += "_" + now.getTime();
		uid += "_" + getTimer();
		uid += "_" + uint(Math.random() * uint.MAX_VALUE);
		uid += "_" + (counter++).toString();
		
		return uid;
	}
}

var counter:uint = 0;