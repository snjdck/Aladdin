package snjdck.g3d.skeleton
{
	import snjdck.g3d.render.DrawUnitCollector3D;

	public class BoneAttachmentsGroup
	{
		private const attachmentsDict:Array = [];
		
		public function BoneAttachmentsGroup()
		{
		}
		
		public function getAttachments(boneId:int):BoneAttachments
		{
			var attachments:BoneAttachments = attachmentsDict[boneId];
			if(null == attachments){
				attachments = new BoneAttachments(boneId);
				attachmentsDict[boneId] = attachments;
			}
			return attachments;
		}
		
		public function collectDrawUnit(collector:DrawUnitCollector3D):void
		{
			for(var i:int=0, n:int=attachmentsDict.length; i<n; ++i){
				var attachments:BoneAttachments = attachmentsDict[i];
				if(attachments != null){
					attachments.collectDrawUnit(collector);
				}
			}
		}
		
		public function onBoneStateChanged(boneStateGroup:BoneStateGroup):void
		{
			for(var i:int=0, n:int=attachmentsDict.length; i<n; ++i){
				var attachments:BoneAttachments = attachmentsDict[i];
				if(attachments != null){
					attachments.onBoneStateChanged(boneStateGroup);
				}
			}
		}
		/*
		public function addAttachment(boneId:int, attachment:Object3D):void
		{
			getAttachments(boneId).addAttachment(attachment);
		}
		
		public function removeAttachment(boneId:int, attachment:Object3D):void
		{
			getAttachments(boneId).removeAttachment(attachment);
		}
		
		public function removeAllAttachments(boneId:int):void
		{
			getAttachments(boneId).removeAllAttachments();
		}
		**/
	}
}