package snjdck.g3d.mesh
{
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.bounds.AABB;
	import snjdck.g3d.parser.Geometry;
	import snjdck.g3d.skeleton.Animation;
	import snjdck.g3d.skeleton.BoneStateGroup;
	import snjdck.g3d.skeleton.Skeleton;
	import snjdck.gpu.asset.AssetMgr;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.IGpuTexture;
	import snjdck.model3d.calcVertexBound;
	
	use namespace ns_g3d;

	public class SubMesh
	{
		public var mesh:Mesh;
		public var materialName:String;
		public var geometry:Geometry;
		
		private const animationBoundDict:Object = {};
		
		public function SubMesh(mesh:Mesh)
		{
			this.mesh = mesh;
		}
		
		public function draw(context3d:GpuContext, boneStateGroup:BoneStateGroup):void
		{
			if(context3d.isFsSlotInUse(0)){
				var texture:IGpuTexture = AssetMgr.Instance.getTexture(materialName);
				context3d.texture = texture;
				context3d.markRecoverableGpuAsset(texture);
			}
			geometry.draw(context3d, boneStateGroup);
		}
		
		public function mergeBound(result:AABB):void
		{
			result.merge(geometry.bound);
		}
		
		public function getAnimationBound(skeleton:Skeleton, animationName:String):AABB
		{
			var bound:AABB = animationBoundDict[animationName];
			if(null == bound){
				bound = new AABB();
				calcAnimationBound(skeleton, animationName, bound);
				animationBoundDict[animationName] = bound;
			}
			return bound;
		}
		
		private function calcAnimationBound(skeleton:Skeleton, animationName:String, outputBound:AABB):void
		{
			transformedVertexData.length = geometry.vertexCount * 3;
			var boneData:BoneData = geometry.boneData;
			var animation:Animation = skeleton.getAnimationByName(animationName);
			boneStateGroup.skeleton = skeleton;
			boneStateGroup.animation = animation;
			for(var i:int=0; i<animation.length; ++i){
				boneStateGroup.position = i;
				skeleton.updateBoneState(boneStateGroup);
				boneData.transformVertex(geometry.getPosData(), transformedVertexData, boneStateGroup);
				calcVertexBound(transformedVertexData, vertexBound);
				outputBound.merge(vertexBound);
			}
		}
		
		static private const boneStateGroup:BoneStateGroup = new BoneStateGroup(null);
		static private const transformedVertexData:Vector.<Number> = new Vector.<Number>();
		static private const vertexBound:AABB = new AABB();
	}
}