package snjdck.g2d.core
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import snjdck.gpu.GpuRender;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.filter.FragmentFilter;

	public interface IDisplayObject2D extends IDisplayObject
	{
		function onUpdate(timeElapsed:int, parentWorldMatrix:Matrix, parentWorldAlpha:Number):void;
		/*
		function collectDrawUnits(collector:Collector2D):void;
		function collectPickUnits(collector:Collector2D, px:Number, py:Number):void;
		*/
		function draw(render:GpuRender, context3d:GpuContext):void;
		function pickup(px:Number, py:Number):IDisplayObject2D;
		
		
		function globalToLocal(point:Point):Point;
		function localToGlobal(point:Point):Point;
		
		function get transform():Matrix;
		
		function get parent():IDisplayObjectContainer2D;
		function set parent(value:IDisplayObjectContainer2D):void;
		
		function get pivotX():Number;
		function set pivotX(value:Number):void;
		
		function get pivotY():Number;
		function set pivotY(value:Number):void;
		
		function get rotation():Number;
		function set rotation(value:Number):void;
		
		function get width():Number;
		function set width(value:Number):void;
		
		function get height():Number;
		function set height(value:Number):void;
		
		function get color():uint;
		function set color(value:uint):void;
		
		function get worldMatrix():Matrix;
		function get worldAlpha():Number;
		
		function hasVisibleArea():Boolean;
		
		function get filter():FragmentFilter;
		function set filter(value:FragmentFilter):void;
		
		function getBounds(targetSpace:IDisplayObject2D, result:Rectangle):void;
		function calcSpaceTransform(targetSpace:IDisplayObject2D, result:Matrix):void;
		function calcWorldMatrix(result:Matrix):void;
	}
}