package snjdck.g3d.parser
{
	import snjdck.g3d.ns_g3d;
	import snjdck.gpu.asset.helper.ShaderName;
	import snjdck.g3d.geom.Ray;
	import snjdck.g3d.geom.RayTestInfo;
	import snjdck.g3d.mesh.BoneData;
	import snjdck.g3d.render.DrawUnit3D;
	
	use namespace ns_g3d;

	public class DynamicGeometry extends Geometry implements IGeometry
	{
		private var tempVertexData:Vector.<Number>;
		ns_g3d var boneData:BoneData;
		
		public function DynamicGeometry(vertexData:Vector.<Number>, indexData:Vector.<uint>, boneData:BoneData=null)
		{
			super(vertexData, indexData);
			this.boneData = boneData || new BoneData(vertexCount);
		}
		
		override public function dispose():void
		{
			super.dispose();
			tempVertexData = null;
			boneData.dispose();
			boneData = null;
		}
		
		override public function get numBones():int
		{
			return boneData.numBones;
		}
		
		ns_g3d function createBoneDict(boneDict:Object):void
		{
			boneData.createBoneDict(boneDict);
		}
		
		override public function getDrawUnit(drawUnit:DrawUnit3D, boneDict:Object):void
		{
			super.getDrawUnit(drawUnit, boneDict);
			
			if(boneData.canRenderByGPU()){
				boneData.getDrawUnit(drawUnit, boneDict);
			}else{
				drawUnit.shaderName = ShaderName.OBJECT;
				syncTempVertexData(boneDict);
				uploadVertexData(tempVertexData);
			}
		}
		
		override public function testRay(ray:Ray, result:RayTestInfo, boneDict:Object):Boolean
		{
			syncTempVertexData(boneDict);
			return testRayImp(ray, result, tempVertexData);
		}
		
		private function syncTempVertexData(boneDict:Object):void
		{
			if(null == tempVertexData){
				tempVertexData = new Vector.<Number>(getPosData().length, true);
			}
			boneData.transformVertex(getPosData(), tempVertexData, boneDict);
		}
	}
}