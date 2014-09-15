package snjdck.g3d.skeleton
{
	import array.del;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.render.DrawUnitCollector3D;

	use namespace ns_g3d;
	
	public class BoneAttachmentGroup
	{
		private var boneAttachmentList:Array;
		
		public function BoneAttachmentGroup()
		{
			boneAttachmentList = [];
		}
		
		public function addAttachment(boneId:int, attachment:Object3D):void
		{
			var list:Vector.<Object3D> = boneAttachmentList[boneId];
			if(null == list){
				boneAttachmentList[boneId] = new <Object3D>[attachment];
			}else{
				list.push(attachment);
			}
		}
		
		public function removeAttachment(boneId:int, attachment:Object3D):void
		{
			var list:Vector.<Object3D> = boneAttachmentList[boneId];
			if(null == list || list.length <= 0){
				return;
			}
			array.del(list, attachment);
		}
		
		public function removeAttachmentsOnBone(boneId:int):void
		{
			var list:Vector.<Object3D> = boneAttachmentList[boneId];
			if(null == list || list.length <= 0){
				return;
			}
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
		}
		
		public function onUpdate(timeElapsed:int):void
		{
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
			const boneCount:int = boneAttachmentList.length;
			for(var boneId:int=0; boneId<boneCount; ++boneId){
				var list:Vector.<Object3D> = boneAttachmentList[boneId];
				if(null == list || list.length <= 0){
					continue;
				}
				collector.pushMatrix(boneStateGroup.getBoneMatrix(boneId));
				for each(var attachment:Object3D in list){
					attachment.collectDrawUnit(collector);
				}
				collector.popMatrix();
			}
		}
	}
}