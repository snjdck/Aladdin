package http
{
	import lambda.call;
	
	import flash.support.ObjectPool;

	internal function handleResponse(ok:Boolean, data:Object, pool:ObjectPool, ldr:Object, handler:Object):void
	{
		pool.setObjectIn(ldr);
		lambda.call(handler, ok, data);
	}
}