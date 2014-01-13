package org.xmlui.impl
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	import org.xmlui.IUICreator;
	import org.xmlui.UICreator;
	import org.xmlui.UIPanel;
	import org.xmlui.support.copyXmlPropIfExist;
	
	public class ImageCreator extends UICreator implements IUICreator
	{
		public function ImageCreator()
		{
		}
		
		public function createUI(elementConfig:XML):*
		{
			var imagePath:String = elementConfig.attribute("src");
			
			var ldr:Loader = new Loader();
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, function(evt:Event):void{
				panel.width = ldr.content.width;
				panel.height = ldr.content.height;
				panel.onResize();
			});
			ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, __onError);
			
			var context:LoaderContext = new LoaderContext();
			copyXmlPropIfExist(context, elementConfig, "imageDecodingPolicy");
			ldr.load(new URLRequest(imagePath), context);
			
			var panel:UIPanel = new UIPanel();
			initProp(panel, elementConfig);
			panel.addChild(ldr);
			return panel;
		}
		
		private function __onError(evt:IOErrorEvent):void
		{
			trace(evt.text);
		}
	}
}