package org.xmlui
{
	public class UIFactory implements IUIFactory
	{
		private var elementTypeDict:Object;
		
		public function UIFactory()
		{
			elementTypeDict = {};
		}
		
		public function regElementType(elementType:String, creator:IUICreator):void
		{
			elementTypeDict[elementType] = creator;
		}
		
		public function createUI(elementConfig:XML):*
		{
			var elementType:String = elementConfig.@type;
			var creator:IUICreator = elementTypeDict[elementType];
			if(null == creator){
				throw new Error("unsupport type:" + elementType);
			}
			return creator.createUI(elementConfig);
		}
	}
}