package snjdck.gpu.projection
{
	internal interface IProjection
	{
		function resize(width:int, height:int):void;
		function offset(dx:Number, dy:Number):void;
	}
}