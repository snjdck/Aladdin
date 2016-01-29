package snjdck.g3d.skeleton
{
	import array.delAt;
	
	import snjdck.g3d.core.DisplayObjectContainer3D;
	import snjdck.g3d.core.Object3D;

	public class BoneAttachmentGroup
	{
		private const attachmentList:Vector.<Object3D> = new Vector.<Object3D>();
		private var boneObject:DisplayObjectContainer3D;
		
		public function BoneAttachmentGroup(boneObject:DisplayObjectContainer3D)
		{
			this.boneObject = boneObject;
		}
		
		public function addAttachment(attachment:Object3D):void
		{
			if(attachmentList.indexOf(attachment) >= 0)
				return;
			attachmentList.push(attachment);
			boneObject.addChild(attachment);
		}
		
		public function removeAttachment(attachment:Object3D):void
		{
			var index:int = attachmentList.indexOf(attachment);
			if(index < 0)
				return;
			delAt(attachmentList, index);
			boneObject.removeChild(attachment);
		}
		
		public function removeAllAttachments():void
		{
			while(attachmentList.length > 0)
				boneObject.removeChild(attachmentList.pop());
		}
	}
}