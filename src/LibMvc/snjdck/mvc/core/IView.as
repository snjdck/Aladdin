package snjdck.mvc.core
{
	import snjdck.mvc.imp.Mediator;
	import snjdck.tesla.kernel.ui.IViewPortLayer;

	public interface IView
	{
		function regMediator(mediator:Mediator):void;
		function delMediator(mediator:Mediator):void;
		function hasMediator(mediator:Mediator):Boolean;
		function mapViewToMediated(viewClsOrName:Object, mediatorCls:Class):void;
		function regMediatorByView(viewTarget:Object):void;
		
		function mapView(viewCls:Class, mediatorCls:Class, layer:IViewPortLayer):void;
	}
}