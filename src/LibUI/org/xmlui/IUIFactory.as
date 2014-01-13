package org.xmlui
{
	public interface IUIFactory
	{
		function regElementType(elementType:String, creator:IUICreator):void;
		function createUI(elementConfig:XML):*;
	}
}