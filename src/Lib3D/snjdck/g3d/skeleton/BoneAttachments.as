package snjdck.g3d.skeleton
{
	import flash.geom.Matrix3D;
	
	import array.delAt;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.geom.Matrix4x4;
	import snjdck.g3d.render.DrawUnitCollector3D;
	
	use namespace ns_g3d;

	public class BoneAttachments
	{
		static private const boneMatrix:Matrix3D = new Matrix3D();
		
		private const attachmentList:Vector.<Object3D> = new Vector.<Object3D>();
		private var boneId:int;
		
		public function BoneAttachments(boneId:int)
		{
			this.boneId = boneId;
		}
		
		public function collectDrawUnit(collector:DrawUnitCollector3D):void
		{
			for(var i:int=0, n:int=attachmentList.length; i<n; ++i){
				var attachment:Object3D = attachmentList[i];
				attachment.collectDrawUnit(collector);
			}
		}
		
		public function onBoneStateChanged(boneStateGroup:BoneStateGroup):void
		{
			if(attachmentList.length <= 0){
				return;
			}
			var boneState:Matrix4x4 = boneStateGroup.getBoneStateLocal(boneId);
			boneState.toMatrix(boneMatrix);
			for(var i:int=0, n:int=attachmentList.length; i<n; ++i){
				var attachment:Object3D = attachmentList[i];
				attachment.worldTransform = boneMatrix;
			}
		}
		
		public function addAttachment(attachment:Object3D):void
		{
			if(attachmentList.indexOf(attachment) >= 0)
				return;
			attachmentList.push(attachment);
		}
		
		public function removeAttachment(attachment:Object3D):void
		{
			var index:int = attachmentList.indexOf(attachment);
			if(index < 0)
				return;
			delAt(attachmentList, index);
		}
		
		public function removeAllAttachments():void
		{
			attachmentList.length = 0;
		}
	}
}