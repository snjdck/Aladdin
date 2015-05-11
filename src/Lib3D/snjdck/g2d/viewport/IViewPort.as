package snjdck.g2d.viewport
{
	public interface IViewPort
	{
		function createLayer(name:String, parentName:String=null):void;
		function getLayer(name:String):IViewPortLayer;
	}
}