package snjdck.gpu
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.geom.d3.createIsoMatrix;
	
	import snjdck.g2d.core.IDisplayObjectContainer2D;
	import snjdck.g2d.impl.DisplayObjectContainer2D;
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.geom.Ray;
	import snjdck.g3d.geom.RayTestInfo;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.IGpuRenderTarget;
	
	use namespace ns_g3d;

	final public class ViewPort3D
	{
		static public const isoMatrix:Matrix3D = createIsoMatrix();
		
		public const scene3d:Object3D = new Object3D();
		public const scene2d:IDisplayObjectContainer2D = new DisplayObjectContainer2D();
		
		private const render:GpuRender = new GpuRender();
		
		private var renderTarget:IGpuRenderTarget;
		
		public function ViewPort3D(renderTarget:IGpuRenderTarget)
		{
			this.renderTarget = renderTarget;
			render.resize(renderTarget.width, renderTarget.height);
		}
		
		public function update(timeElapsed:int):void
		{
			scene3d.onUpdate(timeElapsed, isoMatrix);
			scene2d.onUpdate(timeElapsed, null, 1);
		}
		
		public function draw(context3d:GpuContext):void
		{
			scene3d.preDrawRenderTargets(context3d);
			scene2d.preDrawRenderTargets(context3d);
			
			renderTarget.setRenderToSelf(context3d);
			renderTarget.clear(context3d);
			
			render.drawScene3D(scene3d, context3d);
			render.drawScene2D(scene2d, context3d);
		}
		
		public function pickObjectsUnderPoint(mouseX:Number, mouseY:Number, result:Vector.<RayTestInfo>):void
		{
			var screenPt:Vector3D = new Vector3D(
				mouseX - 0.5 * renderTarget.width,
				0.5 * renderTarget.height - mouseY
			);
			var ray:Ray = new Ray(screenPt, Vector3D.Z_AXIS);
			scene3d.testRay(ray, result);
		}
		
		public function pickNearestObjectUnderPoint(mouseX:Number, mouseY:Number):RayTestInfo
		{
			var result:Vector.<RayTestInfo> = new Vector.<RayTestInfo>();
			
			pickObjectsUnderPoint(mouseX, mouseY, result);
			
			if(result.length < 1){
				return null;
			}
			
			result.sort(__sort);
			return result[0];
		}
		
		static private function __sort(a:RayTestInfo, b:RayTestInfo):int
		{
			var pa:Vector3D = a.globalPos;
			var pb:Vector3D = b.globalPos;
			return pa.z < pb.z ? -1 : 1;
		}
	}
}