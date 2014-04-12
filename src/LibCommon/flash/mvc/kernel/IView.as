package flash.mvc.kernel
{
	import flash.display.DisplayObject;
	import flash.mvc.view.Mediator;

	public interface IView
	{
		function regMediator(mediator:Mediator):void;
		function delMediator(mediator:Mediator):void;
		function hasMediator(mediator:Mediator):Boolean;
		
		function mapView(viewComponent:DisplayObject, mediatorCls:Class):void;
	}
}