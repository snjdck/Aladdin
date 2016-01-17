package snjdck.g3d.obj3d
{
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.bound.AABB;
	import snjdck.g3d.core.Camera3D;
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.pickup.Ray;
	import snjdck.g3d.render.DrawUnitCollector3D;
	import snjdck.g3d.render.IDrawUnit3D;
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.asset.AssetMgr;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.IGpuTexture;
	import snjdck.gpu.support.QuadRender;
	import snjdck.shader.ShaderName;
	
	use namespace ns_g3d;
	
	public class BillBoard extends Object3D implements IDrawUnit3D
	{
		public function BillBoard()
		{
			blendMode = BlendMode.NORMAL;
			
			var s:int = 128 * 128;
			originalBound.setMinMax(-s, -s, 0, s, s, 0);
			markOriginalBoundDirty();
		}
		
		override protected function onHitTest(localRay:Ray):Boolean
		{
			return originalBound.hitRay(localRay, mouseLocation);
		}
		
		override ns_g3d function collectDrawUnit(collector:DrawUnitCollector3D, camera3d:Camera3D):void
		{
			super.collectDrawUnit(collector, camera3d);
			if(camera3d.isInSight(worldBound)){
				collector.addDrawUnit(this);
			}
		}
		/*
		public function isInSight(camera3d:Camera3D):Boolean
		{
			return camera3d.isInSight(aabb);
		}
		*/
		
		public function draw(context3d:GpuContext):void
		{
			/*
			var t1:Vector.<Vector3D> = cameraWorldMatrix.decompose();
			var t2:Vector.<Vector3D> = worldMatrix.decompose();
			t2[1] = t1[1];
			worldMatrix.recompose(t2);
			*/
			var count:int = 256;
			var tex:IGpuTexture = AssetMgr.Instance.getTexture("terrain");
			context3d.texture = tex;
			context3d.setVcM(5, worldTransform);
			context3d.setVc(8, new <Number>[
				count * tex.width, count * tex.height, -0.5, 0,
				count,count,1,1
			]);
			QuadRender.Instance.drawBegin(context3d);
			QuadRender.Instance.drawTriangles(context3d);
		}
		
		public function get shaderName():String
		{
			return ShaderName.BILLBOARD;
		}
	}
}