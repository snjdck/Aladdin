package net.http
{
	import flash.lang.ICloseable;
	import flash.net.URLRequest;
	import flash.net.URLStream;

	public function loadData(request:URLRequest, handler:Object, progress:Function=null, headerDict:Object=null):ICloseable
	{
		configHttpHeader(request, headerDict);
		
		var ldr:URLStream = pool.getObjectOut();
		
		var promise:Promise = new Promise(ldr, [handleResponse, pool, ldr, handler]);
		
		configHttpCallback(ldr, promise.notify, progress);
		
		ldr.load(request);
		
		return promise;
	}
}

import flash.net.URLStream;

import stdlib.components.ObjectPool;

const pool:ObjectPool = new ObjectPool(URLStream);