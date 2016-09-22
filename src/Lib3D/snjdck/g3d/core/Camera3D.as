package snjdck.g3d.core
{
	import array.copy;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.bound.AABB;
	import snjdck.g3d.geom.Quaternion;
	import snjdck.g3d.pickup.Ray;
	
	import stdlib.constant.Unit;
	
	use namespace ns_g3d;
	
	final public class Camera3D
	{
		private const projection:Projection3D = new Projection3D();
		public var enableViewFrusum:Boolean;
		private const viewFrusum:ViewFrustum = new ViewFrustum();
		
		private const _rotation:Quaternion = new Quaternion();
		
		public var bindTarget:Object3D;
		
		private const constData:Vector.<Number> = new Vector.<Number>(12, true);
		
		public function Camera3D(){}
		
		public function setScreenSize(width:int, height:int):void
		{
			viewFrusum.resize(width, height);
			projection.resize(width, height);
			projection.upload(constData);
			constData[7] = 1;
		}
		
		public function set ortho(value:Boolean):void
		{
			if(value){
				_rotation.fromEulerAngles(120 * Unit.RADIAN, 0, -45 * Unit.RADIAN);
				constData[4] = _rotation.x;
				constData[5] = _rotation.y;
				constData[6] = _rotation.z;
				constData[7] = -_rotation.w;
			}else{
				constData[4] = constData[5] = constData[6] = 0;
				constData[7] = 1;
			}
		}
		
		public function update():void
		{
			if(bindTarget != null){
				bindTarget.worldTransform.copyColumnTo(3, viewFrusum.center);
				constData[8] = viewFrusum.center.x;
				constData[9] = viewFrusum.center.y;
				constData[10] = viewFrusum.center.z;
			}else{
				constData[8] = constData[9] = constData[10] = 0;
			}
		}
		
		public function upload(output:Vector.<Number>):void
		{
			copy(constData, output, 12);
		}
		
		public function isInSight(bound:AABB):Boolean
		{
			if(enableViewFrusum)
				return viewFrusum.classify(bound) <= 0;
			return true;
		}
		/**
		 * @param screenX [-w/2, w/2]
		 * @param screenY [-h/2, h/2]
		 */		
		public function getSceneRay(stageX:Number, stageY:Number, ray:Ray):void
		{
			ray.pos.setTo(stageX, stageY, Projection3D.zNear);
			ray.dir.setTo(0, 0, 1);
//			ray.transform(_worldMatrix, ray);
			_rotation.rotateVector(ray.dir, ray.dir);
			_rotation.rotateVector(ray.pos, ray.pos);
			ray.pos.incrementBy(viewFrusum.center);
		}
		/*
		public function world2camera(input:Vector3D, output:Vector3D):void
		{
			matrix44.transformVector(_worldMatrixInvert, input, output);
		}
		//*/
		public function getViewFrustum():ViewFrustum
		{
			return viewFrusum;
		}
		/*
		public function getCameraZ(result:Vector3D):void
		{
			_worldMatrix.copyColumnTo(2, result);
		}
		*/
	}
}