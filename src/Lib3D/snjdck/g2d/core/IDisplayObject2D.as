package snjdck.g2d.core
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import snjdck.g2d.render.Render2D;
	import snjdck.g3d.asset.IGpuContext;

	public interface IDisplayObject2D extends IDisplayObject
	{
		function onUpdate(timeElapsed:int, parentWorldMatrix:Matrix, parentWorldAlpha:Number):void;
		/*
		function collectDrawUnits(collector:Collector2D):void;
		function collectPickUnits(collector:Collector2D, px:Number, py:Number):void;
		*/
		function draw(render2d:Render2D, context3d:IGpuContext):void;
		function pickup(px:Number, py:Number):IDisplayObject2D;
		
		function getRect(targetCoordinateSpace:IDisplayObject2D):Rectangle;
		
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
	}
}