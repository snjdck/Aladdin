package snjdck.g3d.core
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.lang.IDisposable;
	
	import geom3d.createIsoMatrix;
	
	import snjdck.g2d.core.IDisplayObject2D;
	import snjdck.g2d.core.IDisplayObjectContainer2D;
	import snjdck.g2d.impl.DisplayObjectContainer2D;
	import snjdck.g2d.render.Render2D;
	import snjdck.g3d.asset.IGpuContext;
	import snjdck.g3d.asset.IRenderTarget;
	import snjdck.g3d.geom.ProjectionFactory;
	import snjdck.g3d.geom.Ray;
	import snjdck.g3d.geom.RayTestInfo;
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.render.Render3D;
	
	use namespace ns_g3d;

	final public class ViewPort3D implements IDisposable
	{
		public const scene3d:Object3D = new Object3D();
		public const scene2d:IDisplayObjectContainer2D = new DisplayObjectContainer2D();
		
		public const render3d:Render3D = new Render3D();
		public const render2d:Render2D = new Render2D();
		
//		private const collector3d:DrawUnitCollector3D = new DrawUnitCollector3D();
//		private const collector2d:DrawUnitCollector2D = new DrawUnitCollector2D();
		
//		private const pickCollector2d:PickCollector2D = new PickCollector2D();
		
		public var lens:Matrix3D;
		private var isoMatrix:Matrix3D;
		
		private var renderTarget:IRenderTarget;
		
		public function ViewPort3D(renderTarget:IRenderTarget)
		{
			this.renderTarget = renderTarget;
			init();
		}
		
		private function init():void
		{
			render2d.setOrthographicProjection(renderTarget.width, renderTarget.height);
			lens = ProjectionFactory.OrthoLH(renderTarget.width, renderTarget.height, -4000, 4000);
			isoMatrix = createIsoMatrix();
		}
		
		public function update(timeElapsed:int):void
		{
			scene3d.onUpdate(timeElapsed, isoMatrix);
			scene2d.onUpdate(timeElapsed, null, 1);
		}
		
		public function draw(context3d:IGpuContext):void
		{
			renderTarget.onFrameBegin(context3d);
			
			scene3d.preDrawRenderTargets(context3d);
			scene2d.preDrawRenderTargets(context3d);
			
//			scene3d.collectDrawUnit(collector3d, null);
//			scene2d.collectDrawUnits(collector2d);
			
//			collector3d.onFrameBegin();
//			collector2d.onFrameBegin();
			
			context3d.setRenderToTexture(renderTarget);
			renderTarget.clear(context3d);
			
			context3d.setVcM(0, lens);
			scene3d.draw(render3d, context3d);
			
			render2d.uploadProjectionMatrix(context3d);
			scene2d.draw(render2d, context3d);
//			render3d.draw(context3d, collector3d, lens);
//			render2d.draw(context3d, collector2d);
			
//			collector3d.clear();
//			collector2d.clear();
		}
		
		public function dispose():void
		{
		}
		
		public function getObjectUnderPoint(px:Number, py:Number):IDisplayObject2D
		{
			/*
			scene2d.collectPickUnits(pickCollector2d, px, py);
			pickCollector2d.onFrameBegin();
			var firstDrawUnit:DrawUnit2D = pickCollector2d.getFirstDrawUnit();
			return null == firstDrawUnit ? null : firstDrawUnit.target;
			*/
			return scene2d.pickup(px, py);
		}
		
		public function pickObjectsUnderPoint(mouseX:Number, mouseY:Number, result:Vector.<RayTestInfo>):void
		{
			var screenPt:Vector3D = new Vector3D(
				2 * mouseX / renderTarget.width - 1,
				1 - 2 * mouseY / renderTarget.height
			);
			var ray:Ray = new Ray(screenPt, Vector3D.Z_AXIS);
			scene3d.testRay(ray.transformToLocal(lens), result);
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