package snjdck.tesla.kernel.ui
{
	import flash.display.DisplayObjectContainer;
	
	public class ViewPort implements IViewPort
	{
		private var root:DisplayObjectContainer;
		private const layerDict:Object = {};
		
		public function ViewPort(root:DisplayObjectContainer)
		{
			this.root = root;
			init();
		}
		
		private function init():void
		{
			createLayer(ViewPortLayerName.SCENE);
			createLayer(ViewPortLayerName.HUD);
			createLayer(ViewPortLayerName.UI);
			createLayer(ViewPortLayerName.PANEL);
			createLayer(ViewPortLayerName.POPUP);
			createLayer(ViewPortLayerName.NOTICE);
			createLayer(ViewPortLayerName.TOOLTIP);
		}
		
		private function createLayer(name:String, parentName:String=null):void
		{
			var parent:DisplayObjectContainer = parentName ? layerDict[parentName] : root;
			
			var layer:ViewPortLayer = new ViewPortLayer();
			parent.addChild(layer);
			
			layerDict[name] = layer;
		}
		
		public function getLayer(name:String):IViewPortLayer
		{
			return layerDict[name];
		}
	}
}