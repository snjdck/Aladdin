package snjdck.g2d.obj2d
{
	import matrix33.transformCoordsDelta;
	
	import snjdck.g2d.ns_g2d;
	import snjdck.g2d.impl.DisplayObject2D;
	import snjdck.g2d.render.Render2D;
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.core.DisplayObjectContainer3D;
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.render.DrawUnitCollector3D;
	import snjdck.gpu.asset.GpuContext;
	
	use namespace ns_g2d;
	use namespace ns_g3d;
	
	public class Image3D extends DisplayObject2D
	{
		static public const MVP:Vector.<Number> = new <Number>[0,0,2000,-1000,1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0];
		
		private var isMatrixDirty:Boolean = true;
		
		public const root3d:DisplayObjectContainer3D = new DisplayObjectContainer3D();
		private const collector:DrawUnitCollector3D = new DrawUnitCollector3D();
		
		public function Image3D(w:int, h:int)
		{
			width = w;
			height = h;
		}
		
		public function addChild(child:Object3D):void
		{
			root3d.addChild(child);
		}
		
		override public function onUpdate(timeElapsed:int):void
		{
			super.onUpdate(timeElapsed);
			if(isMatrixDirty){
				transformCoordsDelta(transform, width, height, tempPt);
				root3d.syncMatrix2D(worldTransform);
				root3d.x += 0.5 * (tempPt.x - scene.stageWidth);
				root3d.y = 0.5 * (scene.stageHeight - tempPt.y) - root3d.y;
				root3d.rotationZ *= -1;
				isMatrixDirty = false;
			}
			root3d.onUpdate(timeElapsed);
			collector.clear();
			root3d.collectDrawUnit(collector);
		}
		
		override protected function onDraw(render2d:Render2D, context3d:GpuContext):void
		{
			if(root3d.numChildren > 0){
				MVP[0] = 0.5 * context3d.bufferWidth;
				MVP[1] = 0.5 * context3d.bufferHeight;
				context3d.setVc(0, MVP);
				context3d.clearDepth();
				context3d.save();
				collector.draw(context3d);
				context3d.restore();
			}
		}
		
		override protected function onLocalMatrixDirty():void
		{
			super.onLocalMatrixDirty();
			isMatrixDirty = true;
		}
		
		override protected function onWorldMatrixDirty():void
		{
			super.onWorldMatrixDirty();
			isMatrixDirty = true;
		}
	}
}