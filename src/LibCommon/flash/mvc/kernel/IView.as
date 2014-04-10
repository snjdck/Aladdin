package flash.mvc.kernel
{
	import flash.mvc.view.Mediator;

	public interface IView
	{
		function regMediator(mediator:Mediator):void;
		function delMediator(mediator:Mediator):void;
		function hasMediator(mediator:Mediator):Boolean;
		function mapViewToMediated(viewClsOrName:Object, mediatorCls:Class):void;
		function regMediatorByView(viewTarget:Object):void;
		
		function mapView(viewCls:Class, mediatorCls:Class):void;
	}
}