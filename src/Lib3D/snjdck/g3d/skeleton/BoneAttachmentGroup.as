package snjdck.g3d.skeleton
{
	import flash.geom.Matrix3D;
	
	import array.delAt;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.render.DrawUnitCollector3D;

	use namespace ns_g3d;
	
	public class BoneAttachmentGroup
	{
		private var boneAttachmentList:Array;
		private var numAttachments:int;
		
		public function BoneAttachmentGroup()
		{
			boneAttachmentList = [];
			numAttachments = 0;
		}
		
		public function addAttachment(boneId:int, attachment:Object3D):void
		{
			var list:Vector.<Object3D> = boneAttachmentList[boneId];
			if(null == list){
				boneAttachmentList[boneId] = new <Object3D>[attachment];
			}else{
				list.push(attachment);
			}
			++numAttachments;
		}
		
		public function removeAttachment(boneId:int, attachment:Object3D):void
		{
			var list:Vector.<Object3D> = boneAttachmentList[boneId];
			if(null == list || list.length <= 0){
				return;
			}
			var index:int = list.indexOf(attachment);
			if(index >= 0){
				array.delAt(list, index);
				--numAttachments;
			}
		}
		
		public function removeAttachmentsOnBone(boneId:int):void
		{
			var list:Vector.<Object3D> = boneAttachmentList[boneId];
			if(null == list || list.length <= 0){
				return;
			}
			numAttachments -= list.length;
			list.length = 0;
		}
		
		public function removeAllAttachments():void
		{
			for each(var list:Vector.<Object3D> in boneAttachmentList){
				if(null == list || list.length <= 0){
					continue;
				}
				list.length = 0;
			}
			numAttachments = 0;
		}
		
		public function onUpdate(timeElapsed:int):void
		{
			if(numAttachments <= 0){
				return;
			}
			const boneCount:int = boneAttachmentList.length;
			for(var boneId:int=0; boneId<boneCount; ++boneId){
				var list:Vector.<Object3D> = boneAttachmentList[boneId];
				if(null == list || list.length <= 0){
					continue;
				}
				for each(var attachment:Object3D in list){
					attachment.onUpdate(timeElapsed);
				}
			}
		}
		
		public function collectDrawUnits(collector:DrawUnitCollector3D, boneStateGroup:BoneStateGroup):void
		{
			if(numAttachments <= 0){
				return;
			}
			const boneCount:int = boneAttachmentList.length;
			for(var boneId:int=0; boneId<boneCount; ++boneId){
				var list:Vector.<Object3D> = boneAttachmentList[boneId];
				if(null == list || list.length <= 0){
					continue;
				}
				boneStateGroup.getBoneStateLocal(boneId).toMatrix(matrix);
				collector.pushMatrix(matrix);
				for each(var attachment:Object3D in list){
					attachment.collectDrawUnit(collector);
				}
				collector.popMatrix();
			}
		}
		
		static private const matrix:Matrix3D = new Matrix3D();
	}
}