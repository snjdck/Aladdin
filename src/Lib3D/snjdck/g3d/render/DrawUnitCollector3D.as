package snjdck.g3d.render
{
	import flash.geom.Matrix3D;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.core.Camera3D;
	
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
		
		public function cullInvisibleUnits(camera:Camera3D):void
		{
			trace("begin cull");
			cullList(camera, opaqueList);
			cullList(camera, blendList);
		}
		
		private function cullList(camera:Camera3D, list:Vector.<IDrawUnit3D>):void
		{
			for(var i:int=list.length-1; i>=0; --i){
				var drawUnit:IDrawUnit3D = list[i];
				if(!drawUnit.isInSight(camera)){
					trace(drawUnit["name"], "is culled");
					list.splice(i, 1);
				}
			}
		}
	}
}