package snjdck.g3d.core
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import array.copy;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.bound.AABB;
	import snjdck.g3d.pickup.Ray;
	import snjdck.gpu.asset.GpuContext;
	
	use namespace ns_g3d;
	
	/**
	 *   a * x - b * y
	 * ((a * y + b * x) - d * c * z) * e
	 * ((a * y + b * x) * d + c * z) * e

	 *   x - y
	 * ((x + y) - sqrt3 * sqrt2 * z) * -0.5
	 * ((x + y) * sqrt3 + sqrt2 * z) * -0.5
	 */
	final public class Camera3D
	{
		private const projection:Projection3D = new Projection3D();
		public var enableViewFrusum:Boolean;
		private const viewFrusum:ViewFrustum = new ViewFrustum();
		
		private var isWorldMatrixDirty:Boolean = true;
		private const _worldMatrix:Matrix3D = new Matrix3D();
		private const _worldMatrixInvert:Matrix3D = new Matrix3D();
		
		private const localMatrix:Matrix3D = new Matrix3D();
		public var bindTarget:Object3D;
		
		private const cameraData:Vector.<Number> = new Vector.<Number>(8, true);
		
		public function Camera3D(){}
		
		public function setScreenSize(width:int, height:int):void
		{
			projection.resize(width, height);
			viewFrusum.resize(0.5 * width, height);
		}
		
		public function set ortho(value:Boolean):void
		{
			localMatrix.identity();
			if(value){
				localMatrix.appendRotation(120, Vector3D.X_AXIS);
				localMatrix.appendRotation(-45, Vector3D.Z_AXIS);
				cameraData[0] = 1;
				cameraData[1] = 1;
				cameraData[2] = Math.SQRT2;
				cameraData[3] = Math.sqrt(3);
				cameraData[7] = -0.5;
			}else{
				cameraData[0] = cameraData[2] = -1;
				cameraData[1] = cameraData[3] = 0;
				cameraData[7] = 1;
			}
			isWorldMatrixDirty = true;
		}
		
		public function update():void
		{
			if(bindTarget != null){
				isWorldMatrixDirty = true;
			}
			if(!isWorldMatrixDirty){
				return;
			}
			isWorldMatrixDirty = false;
			_worldMatrix.copyFrom(localMatrix);
			if(bindTarget != null){
				_worldMatrix.append(bindTarget.worldTransform);
			}
			_worldMatrixInvert.copyFrom(_worldMatrix);
			_worldMatrixInvert.invert();
			if(enableViewFrusum){
				viewFrusum.updateAABB(_worldMatrix);
			}
		}
		
		public function uploadMVP(context3d:GpuContext):void
		{
			projection.resize(context3d.bufferWidth, context3d.bufferHeight);
			projection.upload(context3d);
			context3d.setVcM(2, _worldMatrixInvert);
		}
		
		public function copyMVP(output:Vector.<Number>):void
		{
			projection.copyTo(output);
			_worldMatrixInvert.copyRawDataTo(output, 8, true);
			copy(cameraData, output, 8, 0, 8);
		}
		
		public function isInSight(bound:AABB):Boolean
		{
			return enableViewFrusum ? viewFrusum.containsAABB(bound) : true;
		}
		/**
		 * @param screenX [-w/2, w/2]
		 * @param screenY [-h/2, h/2]
		 */		
		public function getSceneRay(stageX:Number, stageY:Number, ray:Ray):void
		{
			ray.pos.setTo(stageX, stageY, Projection3D.zNear);
			ray.dir.setTo(0, 0, 1);
			ray.transform(_worldMatrix, ray);
		}
		/*
		public function world2camera(input:Vector3D, output:Vector3D):void
		{
			matrix44.transformVector(_worldMatrixInvert, input, output);
		}
		
		public function getViewFrustum():ViewFrustum
		{
			return viewFrusum;
		}
		
		public function getCameraZ(result:Vector3D):void
		{
			_worldMatrix.copyColumnTo(2, result);
		}
		*/
	}
}