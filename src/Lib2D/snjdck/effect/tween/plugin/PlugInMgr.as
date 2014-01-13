package snjdck.effect.tween.plugin
{
	import dict.hasKey;
	
	internal class PlugInMgr
	{
		private var plugInDict:Object;
		
		public function PlugInMgr()
		{
			plugInDict = {};
			initPlugIns();
		}
		
		private function initPlugIns():void
		{
			reg(new ScalePlugIn());
			reg(new TextPlugIn());
		}
		
		private function reg(plugin:IPlugIn):void
		{
			if(dict.hasKey(plugInDict, plugin.propName)){
				throw new Error(plugin.propName + "has been reged yet!");
			}else{
				plugInDict[plugin.propName] = plugin;
			}
		}
		
		public function hasProp(target:Object, propName:String):Boolean
		{
			var plugin:IPlugIn = plugInDict[propName];
			return plugin ? plugin.hasProp(target) : (propName in target);
		}
		
		public function getProp(target:Object, propName:String):Number
		{
			var plugin:IPlugIn = plugInDict[propName];
			return plugin ? plugin.getProp(target) : target[propName];
		}
		
		public function setProp(target:Object, propName:String, val:Number):void
		{
			var plugin:IPlugIn = plugInDict[propName];
			if(plugin){
				plugin.setProp(target, val);
			}else{
				target[propName] = val;
			}
		}
	}
}