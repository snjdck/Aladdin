package snjdck.g3d.cameras
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import matrix44.transformVectorDelta;
	
	import snjdck.g3d.bounds.AABB;
	import snjdck.g3d.bounds.IBound;
	import snjdck.g3d.bounds.Sphere;
	
	public class ViewFrustum implements IViewFrustum
	{
		private const originalOffset:Vector.<Number> = new Vector.<Number>(4, true);
		private const vertexList:Vector.<Vector3D> = new Vector.<Vector3D>(8, true);
		private const planeList:Vector.<Vector3D> = new Vector.<Vector3D>(4, true);
		
		public function ViewFrustum()
		{
			for(var i:int=0; i<8; ++i){
				vertexList[i] = new Vector3D();
			}
		}
		
		public function addPlane(plane:Vector3D, index:int):void
		{
			planeList[index] = plane;
			originalOffset[index] = plane.w;
		}
		
		public function updateTransform(cameraTransform:Matrix3D):void
		{
			for(var i:int=0; i<4; ++i){
				var v:Vector3D = planeList[i];
				transformVectorDelta(cameraTransform, v, v);
			}
		}
		
		public function updatePosition(position:Vector3D):void
		{
			for(var i:int=0; i<4; ++i){
				var v:Vector3D = planeList[i];
				if(v == null){
					return;
				}
				v.w = v.dotProduct(position) + originalOffset[i];
			}
		}
		
		public function classify(bound:IBound):int
		{
			return bound.onClassify(this);
		}
		
		public function classifySphere(bound:Sphere):int
		{
			return 0;
		}
		
		public function classifyBox(bound:AABB):int
		{
			vertexList[0].x = vertexList[1].x = vertexList[2].x = vertexList[3].x = bound.minX;
			vertexList[4].x = vertexList[5].x = vertexList[6].x = vertexList[7].x = bound.maxX;
			
			vertexList[0].y = vertexList[1].y = vertexList[4].y = vertexList[5].y = bound.minY;
			vertexList[2].y = vertexList[3].y = vertexList[6].y = vertexList[7].y = bound.maxY;
			
			vertexList[0].z = vertexList[2].z = vertexList[4].z = vertexList[6].z = bound.minZ;
			vertexList[1].z = vertexList[3].z = vertexList[5].z = vertexList[7].z = bound.maxZ;
			
			var totalIn:int = 0;
			for(var p:int=0; p<4; ++p){
				var sideIn:int = 8;
				var v:Vector3D = planeList[p];
				var d:Number = v.w;
				for(var i:int=0; i<8; ++i){
					if(v.dotProduct(vertexList[i]) < d){
						--sideIn;
					}
				}
				if(sideIn == 0){
					return ClassifyResult.OUTSIDE;
				}
				if(sideIn == 8){
					++totalIn;
				}
			}
			return (totalIn == 4) ? ClassifyResult.CONTAINS : ClassifyResult.INTERSECT;
		}
		
		public function hitTest(bound:IBound):Boolean
		{
			return bound.onHitTest(this);
		}
		
		public function hitTestBox(bound:AABB):Boolean
		{
			vertexList[0].x = vertexList[1].x = vertexList[2].x = vertexList[3].x = bound.minX;
			vertexList[4].x = vertexList[5].x = vertexList[6].x = vertexList[7].x = bound.maxX;
			
			vertexList[0].y = vertexList[1].y = vertexList[4].y = vertexList[5].y = bound.minY;
			vertexList[2].y = vertexList[3].y = vertexList[6].y = vertexList[7].y = bound.maxY;
			
			vertexList[0].z = vertexList[2].z = vertexList[4].z = vertexList[6].z = bound.minZ;
			vertexList[1].z = vertexList[3].z = vertexList[5].z = vertexList[7].z = bound.maxZ;
			
			for(var p:int=0; p<4; ++p){
				var sideIn:int = 8;
				var v:Vector3D = planeList[p];
				var d:Number = v.w;
				for(var i:int=0; i<8; ++i){
					if(v.dotProduct(vertexList[i]) < d){
						--sideIn;
					}
				}
				if(sideIn == 0){
					return false;
				}
			}
			return true;
		}
		
		public function hitTestSphere(bound:Sphere):Boolean
		{
			return false;
		}
	}
}