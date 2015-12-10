package snjdck.g2d
{
	import snjdck.g2d.impl.DisplayObjectContainer2D;
	import snjdck.g2d.viewport.IViewPort;
	import snjdck.g2d.viewport.IViewPortLayer;
	
	internal class ViewPort2D implements IViewPort
	{
		private const layerDict:Object = {};
		private var root:DisplayObjectContainer2D;
		
		public function ViewPort2D(root:DisplayObjectContainer2D)
		{
			this.root = root;
		}
		
		public function createLayer(name:String, parentName:String=null):void
		{
			var parent:DisplayObjectContainer2D = parentName ? layerDict[parentName] : root;
			
			var layer:DisplayObjectContainer2D = new DisplayObjectContainer2D();
			layer.mouseEnabled = false;
			parent.addChild(layer);
			
			layerDict[name] = layer;
		}
		
		public function getLayer(name:String):IViewPortLayer
		{
			return layerDict[name];
		}
	}
}