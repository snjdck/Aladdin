package flash.http
{
	import flash.support.ObjectPool;
	
	import lambda.call;

	internal function handleResponse(ok:Boolean, data:Object, pool:ObjectPool, ldr:Object, handler:Object):void
	{
		pool.setObjectIn(ldr);
		lambda.call(handler, ok, data);
	}
}