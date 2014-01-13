package org.xmlui.impl
{
	import org.xmlui.IUICreator;
	import org.xmlui.UICreator;
	import org.xmlui.UIPanel;
	
	public class PanelCreator extends UICreator implements IUICreator
	{
		public function PanelCreator()
		{
		}
		
		public function createUI(elementConfig:XML):*
		{
			var ui:UIPanel = new UIPanel();
			initProp(ui, elementConfig);
			return ui;
		}
	}
}