package snjdck.tesla.kernel.services
{
	/**
	 * 或者叫MessageService???
	 */	
	public interface INotificationService
	{
		function showAlert():void;
		function showConfirm():void;
		
		/**
		 * 文字出现在屏幕中央,然后往上飘
		 */		
		function showText():void;
	}
}