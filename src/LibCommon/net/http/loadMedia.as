package net.http
{
	import flash.display.Loader;
	import flash.lang.ICloseable;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	public function loadMedia(target:*, handler:Object, progress:Function=null, context:LoaderContext=null):ICloseable
	{
		var ldr:Loader = pool.getObjectOut();
		
		var promise:Promise = new Promise(ldr, [handleResponse, pool, ldr, handler]);
		
		configHttpCallback(ldr.contentLoaderInfo, promise.notify, progress);
		
		if(target is ByteArray){
			ldr.loadBytes(target, context);
		}else{
			if(!(target is URLRequest)){
				target = new URLRequest(target.toString());
			}
			configHttpHeader(target, null);
			ldr.load(target, context);
		}
		
		return promise;
	}
}

import flash.display.Loader;

import stdlib.components.ObjectPool;

const pool:ObjectPool = new ObjectPool(Loader);