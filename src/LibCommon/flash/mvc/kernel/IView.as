package flash.mvc.kernel
{
	import flash.mvc.view.Mediator;
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