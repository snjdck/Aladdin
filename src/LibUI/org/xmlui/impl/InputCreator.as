package org.xmlui.impl
{
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import org.xmlui.IUICreator;
	import org.xmlui.support.copyXmlPropIfExist;
	
	public class InputCreator extends TextCreator implements IUICreator
	{
		public function InputCreator()
		{
		}
		
		override public function createUI(elementConfig:XML):*
		{
			var label:TextField = super.createUI(elementConfig);
			label.type = TextFieldType.INPUT;
			copyXmlPropIfExist(label, elementConfig, "displayAsPassword");
			copyXmlPropIfExist(label, elementConfig, "restrict");
			copyXmlPropIfExist(label, elementConfig, "maxChars");
			return label;
		}
	}
}