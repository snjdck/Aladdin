package snjdck.gpu
{
	import flash.display3D.Context3DTextureFormat;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.geom.d3.createIsoMatrix;
	
	import snjdck.g2d.core.IDisplayObjectContainer2D;
	import snjdck.g2d.impl.DisplayObjectContainer2D;
	import snjdck.g2d.render.Render2D;
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.geom.Ray;
	import snjdck.g3d.geom.RayTestInfo;
	import snjdck.g3d.render.Render3D;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuRenterTarget;
	
	use namespace ns_g3d;

	final public class ViewPort3D extends GpuRenterTarget
	{
		public const scene3d:Object3D = new Object3D();
		public const scene2d:IDisplayObjectContainer2D = new DisplayObjectContainer2D();
		
		public const render3d:Render3D = new Render3D();
		public const render2d:Render2D = new Render2D();
		
		private var isoMatrix:Matrix3D;
		
		public function ViewPort3D(width:int, height:int, antiAlias:int=0)
		{
			super(width, height, Context3DTextureFormat.BGRA, antiAlias);
			render2d.setScreenSize(width, height);
			render3d.setScreenSize(width, height);
			isoMatrix = createIsoMatrix();
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
			
			context3d.setRenderToTexture(this);
			clear(context3d);
			
			render3d.uploadProjectionMatrix(context3d);
			render3d.draw(scene3d, context3d);
			
			render2d.uploadProjectionMatrix(context3d);
			render2d.render(scene2d, context3d);
		}
		
		public function pickObjectsUnderPoint(mouseX:Number, mouseY:Number, result:Vector.<RayTestInfo>):void
		{
			/*
			var screenPt:Vector3D = new Vector3D(
				2 * mouseX / renderTarget.width - 1,
				1 - 2 * mouseY / renderTarget.height
			);
			*/
			var screenPt:Vector3D = new Vector3D(
				mouseX - 0.5 * width,
				0.5 * height - mouseY
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