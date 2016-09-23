package snjdck.g3d.core
{
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.bound.AABB;
	import snjdck.g3d.geom.Quaternion;
	import snjdck.g3d.pickup.Ray;
	import snjdck.gpu.asset.GpuContext;
	
	import stdlib.constant.Unit;
	
	use namespace ns_g3d;
	
	final public class Camera3D
	{
		static public var zNear	:Number = -10000;
		static public var zFar	:Number =  10000;
		
		public var enableViewFrusum:Boolean;
		private const viewFrusum:ViewFrustum = new ViewFrustum();
		
		private const rotation:Quaternion = new Quaternion();
		
		public var bindTarget:Object3D;
		
		private const constData:Vector.<Number> = new Vector.<Number>(12, true);
		
		public function Camera3D()
		{
			constData[2] = zFar - zNear;
			constData[3] = zNear;
			rotation.fromEulerAngles(120 * Unit.RADIAN, 0, -45 * Unit.RADIAN);
			constData[4] = rotation.x;
			constData[5] = rotation.y;
			constData[6] = rotation.z;
			constData[7] = -rotation.w;
		}
		
		public function setScreenSize(width:int, height:int):void
		{
			viewFrusum.resize(width, height);
			constData[0] = 0.5 * width;
			constData[1] = 0.5 * height;
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
		
		public function upload(context3d:GpuContext):void
		{
			context3d.setVc(0, constData);
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
			ray.pos.setTo(stageX, stageY, zNear);
			ray.dir.setTo(0, 0, 1);
//			ray.transform(_worldMatrix, ray);
			rotation.rotateVector(ray.dir, ray.dir);
			rotation.rotateVector(ray.pos, ray.pos);
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