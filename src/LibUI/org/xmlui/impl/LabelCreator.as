package org.xmlui.impl
{
	import flash.text.TextField;
	
	import org.xmlui.IUICreator;
	import org.xmlui.support.copyXmlPropIfExist;
	
	public class LabelCreator extends TextCreator implements IUICreator
	{
		public function LabelCreator()
		{
		}
		
		override public function createUI(elementConfig:XML):*
		{
			var label:TextField = super.createUI(elementConfig);
			return label;
		}
	}
}