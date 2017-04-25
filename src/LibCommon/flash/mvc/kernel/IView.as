package flash.mvc.kernel
{
	public interface IView
	{
		function regMediator(mediator:IMediator):void;
		function delMediator(mediator:IMediator):void;
		function hasMediator(mediator:IMediator):Boolean;
	}
}