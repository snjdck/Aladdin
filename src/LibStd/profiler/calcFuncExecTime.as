package profiler
{
	import flash.utils.getTimer;

	public function calcFuncExecTime(funcRef:Function, funcArgs:Array=null, count:int=100):Number
	{
		var a:int, b:int, i:int=0;
		
		a = getTimer();
		while(i++ < count){
			funcRef.apply(null, funcArgs);
		}
		b = getTimer();
		
		return (b - a) / count;
	}
}