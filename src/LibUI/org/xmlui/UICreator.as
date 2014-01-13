package org.xmlui
{
	import org.xmlui.alignment.Align;
	import org.xmlui.support.copyXmlPropIfExist;

	public class UICreator
	{
		public function UICreator()
		{
		}
		
		protected function initProp(ui:Object, elementConfig:XML):void
		{
			copyXmlPropIfExist(ui, elementConfig, "id");
			copyXmlPropIfExist(ui, elementConfig, "name");
			copyXmlPropIfExist(ui, elementConfig, "x");
			copyXmlPropIfExist(ui, elementConfig, "y");
			copyXmlPropIfExist(ui, elementConfig, "width");
			copyXmlPropIfExist(ui, elementConfig, "height");
			copyXmlPropIfExist(ui, elementConfig, "visible");
			copyXmlPropIfExist(ui, elementConfig, "alpha");
			copyXmlPropIfExist(ui, elementConfig, "rotation");
			copyXmlPropIfExist(ui, elementConfig, "scaleX");
			copyXmlPropIfExist(ui, elementConfig, "scaleY");
			copyXmlPropIfExist(ui, elementConfig, "cacheAsBitmap");
			copyXmlPropIfExist(ui, elementConfig, "mouseEnabled");
			copyXmlPropIfExist(ui, elementConfig, "mouseChildren");
			if(elementConfig.hasOwnProperty("@align")){
				ui.halign = createAlign(elementConfig.attribute("align"));
			}
			if(elementConfig.hasOwnProperty("@valign")){
				ui.valign = createAlign(elementConfig.attribute("valign"));
			}
		}
		
		private function createAlign(align:String):IAlign
		{
			var pattern:RegExp = /[+\-]\d+/;
			var index:int = align.search(pattern);
			if(index < 0){
				return Align.Create(align, 0);
			}
			return Align.Create(align.slice(0, index), parseFloat(align.slice(index)));
		}
	}
}