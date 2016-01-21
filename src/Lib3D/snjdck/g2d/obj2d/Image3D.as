package snjdck.g2d.obj2d
{
	import flash.utils.getTimer;
	
	import matrix33.transformCoordsDelta;
	
	import snjdck.g2d.ns_g2d;
	import snjdck.g2d.impl.DisplayObject2D;
	import snjdck.g2d.render.Render2D;
	import snjdck.g3d.Scene3D;
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.core.Object3D;
	import snjdck.gpu.asset.GpuContext;
	
	use namespace ns_g2d;
	use namespace ns_g3d;
	
	public class Image3D extends DisplayObject2D
	{
		public const scene3d:Scene3D = new Scene3D();
		private var isMatrixDirty:Boolean = true;
		
		public function Image3D(w:int, h:int)
		{
			scene3d.resize(1000, 600);
			originalBound.setTo(0, 0, w, h);
			markOriginalBoundDirty();
		}
		
		public function addChild(child:Object3D):void
		{
			scene3d.root.addChild(child);
		}
		
		override public function onUpdate(timeElapsed:int):void
		{
			var t1:int = getTimer();
			super.onUpdate(timeElapsed);
			if(isMatrixDirty){
				transformCoordsDelta(transform, width, height, tempPt);
				scene3d.root.syncMatrix2D(worldTransform);
				scene3d.root.x += 0.5 * (tempPt.x - scene.stageWidth);
				scene3d.root.y = 0.5 * (scene.stageHeight - tempPt.y) - scene3d.root.y;
				scene3d.root.rotationZ *= -1;
				isMatrixDirty = false;
			}
			scene3d.update(timeElapsed);
			var t2:int = getTimer();
			trace("image3d update======================", t2 - t1);
		}
		
		override protected function onDraw(render2d:Render2D, context3d:GpuContext):void
		{
			if(scene3d.needDraw()){
				context3d.save();
				context3d.clearDepth();
				scene3d.draw(context3d);
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