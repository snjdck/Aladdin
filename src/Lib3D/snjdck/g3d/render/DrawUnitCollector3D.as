package snjdck.g3d.render
{
	import flash.geom.Matrix3D;
	
	import snjdck.g3d.ns_g3d;
	
	use namespace ns_g3d;

	final public class DrawUnitCollector3D
	{
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
		}
		
		public function addDrawUnit(drawUnit:IDrawUnit3D):void
		{
			if(drawUnit.blendMode.isOpaque()){
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
	}
}