package snjdck.tesla.kernel.services
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import snjdck.mvc.core.IService;

	public interface IPopupService extends IService
	{
		/**
		 * @param popup 弹出框
		 * @return closeHandler
		 */
		function showPopup(popup:DisplayObjectContainer):Function;
		function addPopUp(popup:DisplayObject, modal:Boolean):void;
		function removePopUp(popup:DisplayObject):void;
	}
}