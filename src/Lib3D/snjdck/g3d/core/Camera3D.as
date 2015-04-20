package snjdck.g3d.core
{
	import flash.display3D.Context3DCompareMode;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import matrix44.transformVector;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.bound.AABB;
	import snjdck.g3d.pickup.Ray;
	import snjdck.g3d.projection.Projection3D;
	import snjdck.g3d.render.DrawUnitCollector3D;
	import snjdck.g3d.render.IDrawUnit3D;
	import snjdck.g3d.viewfrustum.ViewFrustum;
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.asset.AssetMgr;
	import snjdck.gpu.asset.GpuContext;
	
	use namespace ns_g3d;

	final public class Camera3D
	{
		public var projection:Projection3D;
		public var viewFrusum:ViewFrustum;
		public var cullingMask:uint;
		public var zOffset:Number = 0;
		
		private const _worldMatrix:Matrix3D = new Matrix3D();
		private const _worldMatrixInvert:Matrix3D = new Matrix3D();
		
		public const localMatrix:Matrix3D = new Matrix3D();
		public var bindTarget:Object3D;
		
		public function Camera3D(){}
		
		public function containsAABB(bound:AABB):Boolean
		{
			return false;
		}
		
		public function appendMatrix(other:Matrix3D):void
		{
			_worldMatrix.append(other);
			_worldMatrixInvert.copyFrom(_worldMatrix);
			_worldMatrixInvert.invert();
		}
		
		public function update():void
		{
			_worldMatrix.copyFrom(localMatrix);
			if(bindTarget != null){
				_worldMatrix.append(bindTarget.prevWorldMatrix);
			}
			_worldMatrix.prependTranslation(0, 0, zOffset);
			_worldMatrixInvert.copyFrom(_worldMatrix);
			_worldMatrixInvert.invert();
			
			viewFrusum.updateAABB(_worldMatrix);
		}
		/**
		 *过滤掉完全看不到的对象 
		 * @param collector
		 * @param context3d
		 * 
		 */		
		public function render(collector:DrawUnitCollector3D, context3d:GpuContext):void
		{
			collector.cullInvisibleUnits(this);
			if(!collector.hasDrawUnits()){
				return;
			}
			drawBegin(context3d);
			
			
			
			var drawUnit:IDrawUnit3D;
			
			//collector.opaqueList.sort(
			/*
			var list:Array = [];
			for each(drawUnit in collector.opaqueList){
				list.push(drawUnit.shaderName);
			}
			list.push(null);
			for each(drawUnit in collector.blendList){
				list.push(drawUnit.shaderName);
			}
			trace("shader names",list);
			*/
			if(collector.opaqueList.length > 0){
				context3d.setDepthTest(true, Context3DCompareMode.LESS_EQUAL);
				context3d.blendMode = BlendMode.NORMAL;
				//Terrain.ins.draw(context3d);
				//				var t1:int = getTimer();
				for each(drawUnit in collector.opaqueList){
					context3d.program = AssetMgr.Instance.getProgram(drawUnit.shaderName);
//					if(viewFrusum.containsAABB(drawUnit.bound)){
						drawUnit.draw(context3d, this);
//					}
				}
				//				trace("culling",getTimer()-t1);
			}
			
			if(collector.blendList.length > 0){
				context3d.setDepthTest(false, Context3DCompareMode.LESS_EQUAL);
				for each(drawUnit in collector.blendList){
					context3d.program = AssetMgr.Instance.getProgram(drawUnit.shaderName);
					context3d.blendMode = drawUnit.blendMode;
//					if(viewFrusum.containsAABB(drawUnit.bound)){
						drawUnit.draw(context3d, this);
//					}
				}
			}
		}
		
		public function isInSight(bound:AABB):Boolean
		{
			return viewFrusum.containsAABB(bound);
		}
		
		private function drawBegin(context3d:GpuContext):void
		{
			projection.upload(context3d);
			context3d.setVcM(2, _worldMatrixInvert);
		}
		
		/**
		 * @param screenX [-1, 1]
		 * @param screenY [-1, 1]
		 */		
		public function getSceneRay(screenX:Number, screenY:Number, ray:Ray):void
		{
			projection.getViewRay(screenX, screenY, ray);
			ray.transform(_worldMatrix, ray);
		}
		
		public function world2camera(input:Vector3D, output:Vector3D):void
		{
			matrix44.transformVector(_worldMatrixInvert, input, output);
		}
		
		public function world2screen(input:Vector3D, output:Vector3D):void
		{
			matrix44.transformVector(_worldMatrixInvert, input, output);
			projection.scene2screen(output, output);
		}
	}
}