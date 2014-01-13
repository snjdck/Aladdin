package org.xmlui.impl
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import org.xmlui.IUICreator;
	import org.xmlui.UICreator;
	import org.xmlui.support.copyXmlPropIfExist;
	
	internal class TextCreator extends UICreator implements IUICreator
	{
		public function TextCreator()
		{
		}
		
		public function createUI(elementConfig:XML):*
		{
			var textField:TextField = new TextField();
			textField.defaultTextFormat = createTextFormat(elementConfig);
			initProp(textField, elementConfig);
			
			copyXmlPropIfExist(textField, elementConfig, "background");
			copyXmlPropIfExist(textField, elementConfig, "backgroundColor");
			copyXmlPropIfExist(textField, elementConfig, "border");
			copyXmlPropIfExist(textField, elementConfig, "borderColor");
			
			copyXmlPropIfExist(textField, elementConfig, "multiline");
			copyXmlPropIfExist(textField, elementConfig, "wordWrap");
			
			copyXmlPropIfExist(textField, elementConfig, "textColor");
			copyXmlPropIfExist(textField, elementConfig, "embedFonts");
			copyXmlPropIfExist(textField, elementConfig, "selectable");
			
			copyXmlPropIfExist(textField, elementConfig, "htmlText");
			copyXmlPropIfExist(textField, elementConfig, "text");
			
			copyXmlPropIfExist(textField, elementConfig, "autoSize");
			
			return textField;
		}
		
		private function createTextFormat(elementConfig:XML):TextFormat
		{
			var textFormat:TextFormat = new TextFormat("宋体", 12);
			
			copyXmlPropIfExist(textFormat, elementConfig, "font");
			copyXmlPropIfExist(textFormat, elementConfig, "size");
			copyXmlPropIfExist(textFormat, elementConfig, "color");
			
			copyXmlPropIfExist(textFormat, elementConfig, "bold");
			copyXmlPropIfExist(textFormat, elementConfig, "italic");
			copyXmlPropIfExist(textFormat, elementConfig, "underline");
			
			copyXmlPropIfExist(textFormat, elementConfig, "textAlign", "align");
			copyXmlPropIfExist(textFormat, elementConfig, "blockIndent");
			copyXmlPropIfExist(textFormat, elementConfig, "indent");
			copyXmlPropIfExist(textFormat, elementConfig, "kerning");
			
			copyXmlPropIfExist(textFormat, elementConfig, "letterSpacing");
			copyXmlPropIfExist(textFormat, elementConfig, "leading");
			
			copyXmlPropIfExist(textFormat, elementConfig, "leftMargin");
			copyXmlPropIfExist(textFormat, elementConfig, "rightMargin");
			
			return textFormat;
		}
	}
}