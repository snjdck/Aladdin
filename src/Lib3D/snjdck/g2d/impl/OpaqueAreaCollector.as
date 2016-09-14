package snjdck.g2d.impl
{
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.support.ObjectPool;
	
	import matrix33.hasRotation;
	
	import snjdck.g2d.render.Render2D;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.render.instance.InstanceRender;

	final public class OpaqueAreaCollector
	{
		private const rectPool:ObjectPool = new ObjectPool(Rectangle);
		private const areaList:Vector.<Rectangle> = new Vector.<Rectangle>();
		private const drawer:OpaqueAreaDrawer = new OpaqueAreaDrawer(areaList);
		
		public function OpaqueAreaCollector(){}
		
		public function clear():void
		{
			rectPool.recyleUsedItems();
			areaList.length = 0;
		}
		
		public function hasOpaqueArea():Boolean
		{
			return areaList.length > 0;
		}
		
		public function add(matrix:Matrix, x:Number, y:Number, width:Number, height:Number):void
		{
			if(hasRotation(matrix)){
				return;
			}
			var rect:Rectangle = rectPool.getObjectOut();
			rect.setTo(x + matrix.tx, y + matrix.ty, width * matrix.a, height * matrix.d);
			areaList.push(rect);
		}
		
		public function preDrawDepth(render2d:Render2D, context3d:GpuContext):void
		{
			InstanceRender.Instance.setVc(render2d, null);
			InstanceRender.Instance.drawQuad(context3d, drawer, areaList.length);
		}
	}
}