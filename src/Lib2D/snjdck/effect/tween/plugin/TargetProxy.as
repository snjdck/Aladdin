package snjdck.effect.tween.plugin
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	public class TargetProxy extends Proxy
	{
		static private const plugInMgr:PlugInMgr = new PlugInMgr();
		
		private var target:Object;
		
		public function TargetProxy(target:Object)
		{
			this.target = target;
		}
		
		public function valueOf():Object
		{
			return target;
		}
		
		override flash_proxy function hasProperty(name:*):Boolean
		{
			return plugInMgr.hasProp(target, name.localName);
		}
		
		override flash_proxy function getProperty(name:*):*
		{
			return plugInMgr.getProp(target, name.localName);
		}
		
		override flash_proxy function setProperty(name:*, value:*):void
		{
			plugInMgr.setProp(target, name.localName, value);
		}
	}
}