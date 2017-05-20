package snjdck.ui.menu
{
	internal interface IMenuItem
	{
		function getWidth():Number;
		function getHeight():Number;
		
		function render(menu:Menu, maxWidth:Number, nextY:Number):void;
	}
}