package org.xmlui.impl
{
	import flash.utils.getDefinitionByName;
	
	import org.xmlui.IUICreator;
	import org.xmlui.UICreator;
	import org.xmlui.support.copyXmlPropIfExist;
	
	import ui.list.List;
	
	public class ListCreator extends UICreator implements IUICreator
	{
		public function ListCreator()
		{
			super();
		}
		
		public function createUI(elementConfig:XML):*
		{
			var list:List = new List();
			initProp(list, elementConfig);
			list.listItemFactory = getDefinitionByName(elementConfig.@itemClass) as Class;
			copyXmlPropIfExist(list, elementConfig, "numCols");
			return list;
		}
	}
}