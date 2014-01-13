package snjdck.g2d.core
{
	import snjdck.g3d.asset.IGpuContext;
	import snjdck.g3d.core.BlendMode;

	public interface IDisplayObject
	{
		function get x():Number;
		function set x(value:Number):void;
		
		function get y():Number;
		function set y(value:Number):void;
		
		function get scaleX():Number;
		function set scaleX(value:Number):void;
		
		function get scaleY():Number;
		function set scaleY(value:Number):void;
		
		function get alpha():Number;
		function set alpha(value:Number):void;
		
		function get visible():Boolean;
		function set visible(value:Boolean):void;
		
		function get opaque():Boolean;
		function set opaque(value:Boolean):void;
		
		function get blendMode():BlendMode;
		function set blendMode(value:BlendMode):void;
		
		function preDrawRenderTargets(context3d:IGpuContext):void;
		function removeFromParent():void;
	}
}