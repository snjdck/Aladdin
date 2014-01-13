package snjdck.common
{
	import lambda.apply;

	public function queueDelayCall(timeDef:Array, callbackDef:Array, fromIndex:int=0):void
	{
		delayCall(function():void{
			apply(callbackDef[fromIndex++]);
			if(fromIndex < timeDef.length){
				delayCall(arguments.callee, timeDef[fromIndex]);
			}
		}, timeDef[fromIndex]);
	}
}