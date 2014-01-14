package snjdck.g3d.obj3d
{
	import d3d.createChild;
	import d3d.removeAllChildren;
	
	import flash.geom.Matrix3D;
	import flash.utils.Dictionary;
	
	import snjdck.g3d.asset.IGpuContext;
	import snjdck.g3d.core.BlendMode;
	import snjdck.g3d.core.Camera3D;
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.geom.Ray;
	import snjdck.g3d.geom.RayTestInfo;
	import snjdck.g3d.mesh.Mesh;
	import snjdck.g3d.mesh.SubMesh;
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.render.DrawUnit3D;
	import snjdck.g3d.render.Render3D;
	import snjdck.g3d.skeleton.Bone;
	import snjdck.g3d.skeleton.Skeleton;
	
	import stdlib.common.inheritProps;
	
	use namespace ns_g3d;

	public class Entity extends Object3D
	{
		ns_g3d var mesh:Mesh;
		ns_g3d var skeleton:Skeleton;
		
		public var castShadow:Boolean;
		
		private var boneDict:Object;
		private var bindDict:Object;
		
		public var aniName:String;
		private var aniTime:int;
		public var timeScale:Number = 1;
		
		public function Entity(mesh:Mesh, boneDict:Object)
		{
			this.mesh = mesh;
			blendMode = BlendMode.NORMAL;
			
			this.boneDict = boneDict;
			
			if(boneDict){
				bindDict = new Dictionary();
				skeleton = mesh.skeleton;
				aniName = skeleton.getAnimationNames()[0];
			}
		}
		
		override public function draw(render3d:Render3D, context3d:IGpuContext):void
		{
			super.draw(render3d, context3d);
			for each(var subMesh:SubMesh in mesh.subMeshes)
			{
				var drawUnit:DrawUnit3D = render3d.getFreeDrawUnit();
				drawUnit.blendFactor = blendMode;
				drawUnit.setWorldMatrix(worldMatrix);
				subMesh.getDrawUnit(drawUnit, boneDict);
				render3d.renderDrawUnit(drawUnit, context3d);
			}
		}
		/*
		override ns_g3d function collectDrawUnit(collector:DrawUnitCollector3D, camera:Camera3D):void
		{
			super.collectDrawUnit(collector, camera);
			
			if(!camera.viewFrustum.isBoundVisible(mesh.bound, worldMatrix)){
				++collector.numCulledEntities;
				collector.numCulledDrawUnits += mesh.subMeshes.length;
				return;
			}
			
			
			for each(var subMesh:SubMesh in mesh.subMeshes)
			{
				var drawUnit:DrawUnit3D = collector.getFreeDrawUnit();
				drawUnit.blendFactor = blendMode;
				drawUnit.setWorldMatrix(worldMatrix);
				subMesh.getDrawUnit(drawUnit, boneDict);
				collector.addDrawUnit(drawUnit);
			}
		}
		*/
		override protected function onTestRay(globalRay:Ray, result:Vector.<RayTestInfo>):void
		{
			var ray:Ray = getLocalRay(globalRay);
			
			var rayTestInfo:RayTestInfo = new RayTestInfo();
			rayTestInfo.target = this;
			
			for each(var subMesh:SubMesh in mesh.subMeshes){
				if(subMesh.testRay(ray, boneDict, rayTestInfo)){
					result.push(rayTestInfo);
					return;
				}
			}
		}
		
		private function checkBoneName(boneName:String):Bone
		{
			var bone:Bone = skeleton.getBoneByName(boneName);
			if(null == bone){
				throw new Error("boneName '" + boneName + "' not exist!");
			}
			return bone;
		}
		
		public function bindEntityToBone(boneName:String, entity:Object3D):void
		{
			var boneId:int = checkBoneName(boneName).id;
			bindDict[boneId] ||= createChild(this, boneName).localMatrix;
			getChild(boneName).addChild(entity);
		}
		
		public function unbindEntityFromBone(boneName:String, entity:Entity):void
		{
			checkBoneName(boneName);
			getChild(boneName).removeChild(entity);
		}
		
		public function unbindAllEntitiesFromBone(boneName:String):void
		{
			checkBoneName(boneName);
			removeAllChildren(getChild(boneName));
		}
		
		public function shareSkeletonInstanceWith(entity:Entity):void
		{
			skeleton = null;
			inheritProps(entity.boneDict, boneDict);
			boneDict = entity.boneDict;
		}
		
		override ns_g3d function onUpdate(timeElapsed:int, parentWorldMatrix:Matrix3D):void
		{
			super.onUpdate(timeElapsed, parentWorldMatrix);
			
			if(null == boneDict || null == skeleton){
				return;
			}
			
			const len:int = skeleton.getAnimationLength(aniName) * 1000;
			aniTime += timeElapsed * timeScale;
			if(aniTime > len){
				aniTime -= len;
			}
			
			skeleton.onUpdate(aniName, aniTime * 0.001);
			
			var boneId:*;
			
			for(boneId in boneDict){
				skeleton.copyBoneMatrix(boneId, boneDict[boneId]);
			}
			
			for(boneId in bindDict){
				skeleton.copyBindMatrix(boneId, bindDict[boneId]);
			}
		}
	}
}