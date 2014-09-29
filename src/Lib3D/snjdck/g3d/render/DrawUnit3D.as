package snjdck.g3d.render
{
	import flash.geom.Matrix3D;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.skeleton.Transform;
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuIndexBuffer;
	import snjdck.gpu.asset.GpuVertexBuffer;
	import snjdck.gpu.register.VertexRegister;
	
	import string.replace;
	
	use namespace ns_g3d;

	final public class DrawUnit3D
	{
		static private const MAX_VA_COUNT:uint = 8;
		static private const MAX_FS_COUNT:uint = 8;
		
		public var layer:uint;
		
		private const floatBuffer:Vector.<Number> = new Vector.<Number>(129*4, true);
		
		private var vaSlot:VertexRegister;
		
		private const _worldMatrix:Matrix3D = new Matrix3D();
		private const _boneList:Vector.<Transform> = new Vector.<Transform>();
		
		public var shaderName:String;
		public var textureName:String;
		
		ns_g3d var indexBuffer:GpuIndexBuffer;
		
		ns_g3d var blendMode:BlendMode;
		
		public function DrawUnit3D()
		{
			vaSlot = new VertexRegister(MAX_VA_COUNT);
			clear();
		}
		
		ns_g3d function clear():void
		{
			vaSlot.clear();
			_boneList.length = 0;
			
			shaderName = null;
			textureName = null;
			
			indexBuffer = null;
			
			blendMode = BlendMode.NORMAL;
		}
		
		ns_g3d function set worldMatrix(matrix:Matrix3D):void
		{
			_worldMatrix.copyFrom(matrix);
		}
		
		ns_g3d function addBone(bone:Transform):void
		{
			_boneList[_boneList.length] = bone;
		}
		
		ns_g3d function setVa(slotIndex:int, buffer:GpuVertexBuffer, offset:int=-1, format:String=null):void
		{
			vaSlot.setVa(slotIndex, buffer, offset, format);
		}
		
		public function exec(context3d:GpuContext):void
		{
			context3d.blendMode = blendMode;
			
			vaSlot.upload(context3d);
			uploadConst(context3d);
			
			context3d.drawTriangles(indexBuffer);
		}
		
		private function uploadConst(context3d:GpuContext):void
		{
			const boneCount:int = _boneList.length;
			if(boneCount <= 0){
				context3d.setVcM(5, _worldMatrix);
				return;
			}
			_worldMatrix.copyRawDataTo(floatBuffer, 0, true);
			var offset:int = 12;
			for(var i:int=0; i<boneCount; ++i){
				var bone:Transform = _boneList[i];
				bone.copyRawDataTo(floatBuffer, offset);
				offset += 8;
			}
			context3d.setVc(5, floatBuffer, offset >> 2);
		}
		
		public function toString():String
		{
			return string.replace("{shader=${0}, texture=${1}}", [shaderName, textureName]);
		}
	}
}