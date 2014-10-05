package snjdck.g3d.render
{
	import flash.geom.Matrix3D;
	import flash.support.ObjectPool;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.core.Camera3D;
	import snjdck.g3d.core.Object3D;
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.matrixstack.MatrixStack3D;
	
	use namespace ns_g3d;

	final public class DrawUnitCollector3D
	{
		static private const drawUnitPool:ObjectPool = new ObjectPool(DrawUnit3D);
		
		private const matrixStack:MatrixStack3D = new MatrixStack3D();
		
		ns_g3d const opaqueList:Vector.<DrawUnit3D> = new Vector.<DrawUnit3D>();
		ns_g3d const blendList:Vector.<DrawUnit3D> = new Vector.<DrawUnit3D>();
		ns_g3d const cameraList:Vector.<Camera3D> = new Vector.<Camera3D>();
		
		ns_g3d var root:Object3D;
		
		public function DrawUnitCollector3D(){}
		
		public function clear():void
		{
			while(opaqueList.length > 0){
				recoverDrawUnit(opaqueList.pop());
			}
			while(blendList.length > 0){
				recoverDrawUnit(blendList.pop());
			}
			cameraList.length = 0;
			root = null;
		}
		
		private function recoverDrawUnit(drawUnit:DrawUnit3D):void
		{
			drawUnit.clear();
			drawUnitPool.setObjectIn(drawUnit);
		}
		
		public function getFreeDrawUnit():DrawUnit3D
		{
			return drawUnitPool.getObjectOut();
		}
		
		public function addDrawUnit(drawUnit:DrawUnit3D):void
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
		
		public function addCamera(camera:Camera3D):void
		{
			cameraList.push(camera);
		}
		
		public function drawBegin():void
		{
			cameraList.sort(__sortCamera);
		}
		
		static private function __sortCamera(left:Camera3D, right:Camera3D):int
		{
			return left.depth - right.depth;
		}
	}
}