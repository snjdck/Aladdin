package snjdck.g3d.obj3d
{
	import flash.geom.Matrix3D;
	
	import array.del;
	import array.pushIfNotHas;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.bound.AABB;
	import snjdck.g3d.core.Camera3D;
	import snjdck.g3d.core.DisplayObjectContainer3D;
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.mesh.Mesh;
	import snjdck.g3d.mesh.SubMesh;
	import snjdck.g3d.parser.Geometry;
	import snjdck.g3d.pickup.Ray;
	import snjdck.g3d.render.DrawUnitCollector3D;
	import snjdck.g3d.render.IDrawUnit3D;
	import snjdck.g3d.skeleton.Bone;
	import snjdck.g3d.skeleton.BoneStateGroup;
	import snjdck.g3d.skeleton.Skeleton;
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.shader.ShaderName;
	
	use namespace ns_g3d;

	public class Entity extends DisplayObjectContainer3D implements IDrawUnit3D
	{
		private const subEntityList:Vector.<SubEntity> = new Vector.<SubEntity>();
		private var hasSkeleton:Boolean;
		private var skeleton:Skeleton;
		
		private var boneStateGroup:BoneStateGroup = new BoneStateGroup();
		private const boneDict:Object = {};
		
		public function Entity(mesh:Mesh)
		{
			blendMode = BlendMode.NORMAL;
			
			for each(var subMesh:SubMesh in mesh.subMeshes){
				subEntityList.push(new SubEntity(subMesh));
			}
			
			hasSkeleton = (mesh.skeleton != null);
			
			if(hasSkeleton){
				skeleton = mesh.skeleton;
				aniName = skeleton.getAnimationNames()[0];
				boneStateGroup.skeleton = skeleton;
			}
		}
		
		private function isInSight(camera3d:Camera3D):Boolean
		{
			for each(var subEntity:SubEntity in subEntityList){
				if(!subEntity.visible){
					continue;
				}
				if(!camera3d.enableViewFrusum){
					return true;
				}
				subEntity.updateWorldBound(worldTransform);
				if(camera3d.isInSight(subEntity.worldBound)){
					return true;
				}
			}
			for each(var mesh:Mesh in _meshList){
				for each(var subMesh:SubMesh in mesh.subMeshes){
					if(!camera3d.enableViewFrusum){
						return true;
					}
					subMesh.calcWorldBound(worldTransform, tempBound);
					if(camera3d.isInSight(tempBound)){
						return true;
					}
				}
			}
			return false;
		}
		
		public function draw(context3d:GpuContext, camera3d:Camera3D):void
		{
			context3d.setVcM(Geometry.WORLD_MATRIX_OFFSET, worldTransform);
			for each(var subEntity:SubEntity in subEntityList){
				if(subEntity.visible){
					subEntity.draw(context3d, boneStateGroup);
				}
			}
			for each(var mesh:Mesh in _meshList){
				for each(var subMesh:SubMesh in mesh.subMeshes){
					subMesh.draw(context3d, boneStateGroup);
				}
			}
		}
		
		public function get shaderName():String
		{
			return hasSkeleton ? ShaderName.DYNAMIC_OBJECT : ShaderName.STATIC_OBJECT;
		}
		
		override ns_g3d function collectDrawUnit(collector:DrawUnitCollector3D, camera3d:Camera3D):void
		{
			super.collectDrawUnit(collector, camera3d);
			if(isInSight(camera3d)){
				collector.addDrawUnit(this);
			}
		}
		
		override protected function onHitTest(localRay:Ray):Boolean
		{
			for each(var subEntity:SubEntity in subEntityList){
				if(subEntity.visible && subEntity.testRay(localRay, mouseLocation)){
					return true;
				}
			}
			return false;
		}
		
		private function getBoneObject(boneName:String):DisplayObjectContainer3D
		{
			var bone:Bone = skeleton.getBoneByName(boneName);
			if(null == bone){
				throw new Error("boneName '" + boneName + "' not exist!");
			}
			var boneObject:DisplayObjectContainer3D = boneDict[boneName];
			if(boneObject == null){
				boneObject = new DisplayObjectContainer3D();
				addChild(boneObject);
				boneObject.id = bone.id;
				boneDict[boneName] = boneObject;
			}
			return boneObject;
		}
		
		public function bindEntityToBone(boneName:String, entity:Object3D):void
		{
			getBoneObject(boneName).addChild(entity);
		}
		
		public function unbindEntityFromBone(boneName:String, entity:Entity):void
		{
			getBoneObject(boneName).removeChild(entity);
		}
		
		public function unbindAllEntitiesFromBone(boneName:String):void
		{
			getBoneObject(boneName).removeAllChildren();
		}
		
		public function shareSkeletonInstanceWith(entity:Entity):void
		{
			skeleton = null;
			boneStateGroup = entity.boneStateGroup;
		}
		
		override public function onUpdate(timeElapsed:int):void
		{
			updateBoneState(timeElapsed);
			if(!hasSkeleton)
				return;
			for each(var boneObject:DisplayObjectContainer3D in boneDict){
				if(boneObject.numChildren <= 0)
					continue;
				var matrix:Matrix3D = boneObject.worldTransform;
				boneStateGroup.getBoneStateLocal(boneObject.id).toMatrix(matrix);
				boneObject.worldTransform = matrix;
			}
		}
		
		public function set aniName(value:String):void
		{
			boneStateGroup.animation = skeleton.getAnimationByName(value);
		}
		
		public function updateBoneState(timeElapsed:int):void
		{
			if(skeleton != null){
				boneStateGroup.advanceTime(timeElapsed * 0.001);
			}
		}
		
		public function calculateBound():void
		{
			for each(var subEntity:SubEntity in subEntityList){
				subEntity.updateWorldBound(worldTransform);
			}
		}
		
		public function getEntityBound(bound:AABB):void
		{
			if(subEntityList.length < 1){
				return;
			}
			var subEntity:SubEntity = subEntityList[0];
			bound.copyFrom(subEntity.worldBound);
			for(var i:int=subEntityList.length-1; i > 0; --i){
				subEntity = subEntityList[i];
				bound.merge(subEntity.worldBound);
			}
		}
		
		private const _meshList:Vector.<Mesh> = new Vector.<Mesh>();
		
		public function addMesh(child:Mesh):void
		{
			pushIfNotHas(_meshList, child);
		}
		
		public function removeMesh(child:Mesh):void
		{
			array.del(_meshList, child);
		}
		
		static private const tempBound:AABB = new AABB();
		
		public function bindBoneStateGroup(value:BoneStateGroup):void
		{
			skeleton = null;
			boneStateGroup = value;
		}
		
		public function clearSkeleton():void
		{
			hasSkeleton = false;
			skeleton = null;
		}
		
		public function showSubMeshAt(index:int):void
		{
			setSubMeshVisible(index, true);
		}
		
		public function hideSubMeshAt(index:int):void
		{
			setSubMeshVisible(index, false);
		}
		
		public function setSubMeshVisible(index:int, value:Boolean):void
		{
			if(0 <= index && index < subEntityList.length){
				subEntityList[index].visible = value;
			}
		}
	}
}