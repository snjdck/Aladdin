package flash.support
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	import avm2.intrinsics.iteration.hasnext;
	import avm2.intrinsics.iteration.nextname;
	import avm2.intrinsics.iteration.nextvalue;
	
	public class DataProxy extends Proxy
	{
		private var rawData:Object;
		
		public function DataProxy(data:Object)
		{
			rawData = data;
		}
		
		override flash_proxy function hasProperty(name:*):Boolean
		{
			var key:String = (name as QName).localName;
			return key in rawData;
		}
		
		override flash_proxy function getProperty(name:*):*
		{
			var key:String = (name as QName).localName;
			return rawData[key];
		}
		
		override flash_proxy function setProperty(name:*, value:*):void
		{
			var key:String = (name as QName).localName;
			rawData[key] = value;
		}
		
		override flash_proxy function deleteProperty(name:*):Boolean
		{
			var key:String = (name as QName).localName;
			return delete rawData[key];
		}
		
		override flash_proxy function callProperty(name:*, ...parameters):*
		{
			var key:String = (name as QName).localName;
			var handler:Function = rawData[key];
			return handler.apply(this, parameters);
		}
		
		override flash_proxy function nextNameIndex(index:int):int
		{
			return hasnext(rawData, index) ? (index + 1) : 0;
		}
		
		override flash_proxy function nextName(index:int):String
		{
			return nextname(rawData, index);
		}
		
		override flash_proxy function nextValue(index:int):*
		{
			return nextvalue(rawData, index);
		}
	}
}