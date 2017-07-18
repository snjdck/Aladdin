package snjdck.g3d.cameras
{
	import flash.geom.Vector3D;
	
	import snjdck.gpu.asset.GpuContext;

	public class ProjectionData
	{
		private var constData:Vector.<Number>;
		/*
		private var isOrthoMode:Boolean;
		
		private var halfHeightRecip:Number;
		private var halfFovYRecip:Number;
		private var aspectRatio:Number;
		*/
		public function ProjectionData(useOrthoMode:Boolean=false)
		{
			constData = new Vector.<Number>(8, true);
//			setOrthoMode(useOrthoMode);
		}
		
		public function upload(context3d:GpuContext):void
		{
			context3d.setVc(0, constData, 2);
		}
		
		public function setViewPort(width:int, height:int):void
		{
//			if(isOrthoMode){
				constData[0] = 0.5 * width;
				constData[1] = 0.5 * height;
//			}else{
//				constData[0] = halfFovY * width / height;
//				constData[1] = halfFovY;
//				halfHeightRecip = 2 / height;
//				halfFovYRecip = 1 / halfFovY;
//				aspectRatio = width / height;
//			}
		}
		/*
		private function setOrthoMode(value:Boolean):void
		{
			isOrthoMode = value;
			constData[4] = isOrthoMode ? 0 : 1;
			constData[5] = isOrthoMode ? 1 : 0;
		}
		*/
		public function get zNear():Number
		{
			return constData[3];
		}
		
		public function set zNear(value:Number):void
		{
			constData[3] = value;
		}
		
		public function set zRange(value:Number):void
		{
			constData[2] = value;
		}
		
		public function get zOffset():Number
		{
			return constData[6];
		}
		
		public function set zOffset(value:Number):void
		{
			constData[6] = value;
		}
		
		/**
		 * @param screenX [-w/2, w/2]
		 * @param screenY [-h/2, h/2]
		 */
		public function calcCameraSpaceRay(screenX:Number, screenY:Number, position:Vector3D, direction:Vector3D):void
		{
//			if(isOrthoMode){
				position.setTo(screenX, screenY, zNear);
				direction.setTo(0, 0, 1);
//			}else{
//				position.setTo(0, 0, zOffset);
//				direction.setTo(screenX * halfHeightRecip, screenY * halfHeightRecip, halfFovYRecip);
//			}
		}
		
//		public function calcViewFrustum(viewFrustum:ViewFrustum):void
//		{
//			var tl:Vector3D = new Vector3D(-aspectRatio,  1, halfFovYRecip);
//			var tr:Vector3D = new Vector3D( aspectRatio,  1, halfFovYRecip);
//			var bl:Vector3D = new Vector3D(-aspectRatio, -1, halfFovYRecip);
//			var br:Vector3D = new Vector3D( aspectRatio, -1, halfFovYRecip);
//			
//			var tp:Vector3D = tr.crossProduct(tl);
//			var lp:Vector3D = tl.crossProduct(bl);
//			
//			tp.normalize();
//			lp.normalize();
//			
//			tp.w = tp.z * zOffset;
//			lp.w = lp.z * zOffset;
//			
//			var bp:Vector3D = new Vector3D(0, -tp.y, tp.z, tp.w);
//			var rp:Vector3D = new Vector3D(-lp.x, 0, lp.z, lp.w);
//			
//			viewFrustum.addPlane(tp, 0);
//			viewFrustum.addPlane(lp, 1);
//			viewFrustum.addPlane(bp, 2);
//			viewFrustum.addPlane(rp, 3);
			/*
			var xAxis:Vector3D = new Vector3D();
			var yAxis:Vector3D = new Vector3D();
			
			cameraTransformInvert.copyColumnTo(0, xAxis);
			cameraTransformInvert.copyColumnTo(1, yAxis);
			xAxis = cameraTransformInvert.deltaTransformVector(Vector3D.X_AXIS);
			yAxis = cameraTransformInvert.deltaTransformVector(Vector3D.Y_AXIS);
			
			var t1:Vector3D = tl.crossProduct(yAxis);
			var t2:Vector3D = yAxis.crossProduct(br);
			var t3:Vector3D = xAxis.crossProduct(tr);
			var t4:Vector3D = bl.crossProduct(xAxis);
			
			t1.normalize();
			t2.normalize();
			t3.normalize();
			t4.normalize();
			
			t1.w = t1.z * zOffset;
			t2.w = t2.z * zOffset;
			t3.w = t3.z * zOffset;
			t4.w = t4.z * zOffset;
			
			viewFrustum.addPlane(t1, 4);
			viewFrustum.addPlane(t2, 5);
			viewFrustum.addPlane(t3, 6);
			viewFrustum.addPlane(t4, 7);
			//*/
//		}
	}
}