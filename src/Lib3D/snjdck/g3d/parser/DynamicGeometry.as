package snjdck.g3d.parser
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.mesh.BoneData;
	import snjdck.g3d.pickup.Ray;
	import snjdck.g3d.skeleton.BoneStateGroup;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.shader.ShaderName;
	
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
		
		override public function testRay(ray:Ray, mouseLocation:Vector3D, boneStateGroup:BoneStateGroup):Boolean
		{
//			syncTempVertexData(boneStateGroup);
			return testRayImp(ray, mouseLocation, tempVertexData);
		}
		/*
		private function syncTempVertexData(boneStateGroup:BoneStateGroup):void
		{
			if(null == tempVertexData){
				tempVertexData = new Vector.<Number>(getPosData().length, true);
			}
			boneData.transformVertex(getPosData(), tempVertexData, boneStateGroup);
		}
		*/
		override protected function onDraw(context3d:GpuContext, worldMatrix:Matrix3D, boneStateGroup:BoneStateGroup):void
		{
//			if(boneData.canRenderByGPU()){
				boneData.draw(context3d, worldMatrix, boneStateGroup);
//			}else{
//				syncTempVertexData(boneStateGroup);
//				uploadVertexData(tempVertexData);
//			}
		}
	}
}