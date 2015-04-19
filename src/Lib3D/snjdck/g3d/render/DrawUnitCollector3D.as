package snjdck.g3d.render
{
	import flash.geom.Matrix3D;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.matrixstack.MatrixStack3D;
	
	use namespace ns_g3d;

	final public class DrawUnitCollector3D
	{
//		static private const drawUnitPool:ObjectPool = new ObjectPool(DrawUnit3D);
		
		private const matrixStack:MatrixStack3D = new MatrixStack3D();
		
		ns_g3d const opaqueList:Vector.<IDrawUnit3D> = new Vector.<IDrawUnit3D>();
		ns_g3d const blendList:Vector.<IDrawUnit3D> = new Vector.<IDrawUnit3D>();
		
		public function DrawUnitCollector3D(){}
		
		public function hasDrawUnits():Boolean
		{
			return (opaqueList.length > 0) || (blendList.length > 0);
		}
		
		public function clear():void
		{
			opaqueList.length = 0;
			blendList.length = 0;
			/*
			while(opaqueList.length > 0){
				recoverDrawUnit(opaqueList.pop() as DrawUnit3D);
			}
			while(blendList.length > 0){
				recoverDrawUnit(blendList.pop());
			}
			*/
		}
		/*
		private function recoverDrawUnit(drawUnit:DrawUnit3D):void
		{
			if(null == drawUnit){
				return;
			}
			drawUnit.clear();
			drawUnitPool.setObjectIn(drawUnit);
		}
		
		public function getFreeDrawUnit():DrawUnit3D
		{
			return drawUnitPool.getObjectOut();
		}
		*/
		public function addDrawUnit(drawUnit:IDrawUnit3D):void
		{
			if(drawUnit.blendMode.equals(BlendMode.NORMAL)){
				opaqueList.push(drawUnit);
			}else{
				blendList.push(drawUnit);
			}
		}
		
		public function pushMatrix(matrix:Matrix3D):void
		{
			matrixStack.pushMatrix(matrix);
		}
		
		public function popMatrix():void
		{
			matrixStack.popMatrix();
		}
		
		public function get worldMatrix():Matrix3D
		{
			return matrixStack.worldMatrix;
		}
		/*
		public function addCamera(camera:CameraUnit3D):void
		{
			var index:int = findCameraIndex(camera);
			array.insert(cameraList, index, camera);
		}
		
		private function findCameraIndex(camera:CameraUnit3D):int
		{
			for(var i:int=cameraList.length; i>0; --i){
				var testCamera:CameraUnit3D = cameraList[i-1];
				if(camera.depth >= testCamera.depth){
					return i;
				}
			}
			return 0;
		}
		*/
	}
}