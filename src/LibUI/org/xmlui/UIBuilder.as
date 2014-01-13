package org.xmlui
{
	import org.xmlui.impl.ButtonCreator;
	import org.xmlui.impl.ImageCreator;
	import org.xmlui.impl.InputCreator;
	import org.xmlui.impl.LabelCreator;
	import org.xmlui.impl.ListCreator;
	import org.xmlui.impl.PanelCreator;

	public class UIBuilder
	{
		static private var instance:UIBuilder;
		
		static public function getInstance():UIBuilder
		{
			if(null == instance){
				instance = new UIBuilder();
			}
			return instance;
		}
		
		private var factory:IUIFactory;
		
		public function UIBuilder()
		{
			factory = new UIFactory();
			factory.regElementType("panel", new PanelCreator());
			factory.regElementType("image", new ImageCreator());
			factory.regElementType("label", new LabelCreator());
			factory.regElementType("input", new InputCreator());
			factory.regElementType("button", new ButtonCreator());
			factory.regElementType("list", new ListCreator());
		}
		
		public function build(elementConfig:XML):UIPanel
		{
			var templeteDict:Object = {};
			var ui:UIPanel = buildImpl(elementConfig, templeteDict);
			ui.onResize();
			return ui;
		}
		
		private function buildImpl(elementConfig:XML, templeteDict:Object):*
		{
			processInherit(elementConfig, templeteDict);
			var container:Object = factory.createUI(elementConfig);
			for each(var childElementConfig:XML in elementConfig.children())
			{
				switch(childElementConfig.localName())
				{
					case "ui":
						container.addChild(buildImpl(childElementConfig, templeteDict));
						break;
					case "templete":
						registerTemplete(childElementConfig, templeteDict);
						break;
				}
			}
			return container;
		}
		
		private function processInherit(elementConfig:XML, templeteDict:Object):void
		{
			var inherit:XMLList = elementConfig.attribute("inherit");
			if(inherit.length() <= 0){
				return;
			}
			var templete:Object = templeteDict[inherit.toString()];
			for(var prop:String in templete){
				if(!elementConfig.hasOwnProperty("@"+prop)){
					elementConfig.@[prop] = templete[prop];
				}
			}
		}
		
		public function registerTemplete(elementConfig:XML, templeteDict:Object):void
		{
			if(elementConfig.hasComplexContent()){
				throw new Error("complex templete is not support yet!");
			}
			
			var result:Object = {};
			var inherit:String;
			
			for each(var propXml:XML in elementConfig.attributes())
			{
				var propName:String = propXml.localName();
				var propValue:String = propXml.toString();
				switch(propName)
				{
					case "id":
						templeteDict[propValue] = result;
						break;
					case "inherit":
						inherit = propValue;
						break;
					default:
						result[propName] = propValue;
				}
			}
			
			if(inherit){
				inheritProps(result, templeteDict[inherit]);
			}
		}
		
		private function inheritProps(target:Object, parent:Object):void
		{
			for(var prop:String in parent){
				if(!(prop in target)){
					target[prop] = parent[prop];
				}
			}
		}
	}
}