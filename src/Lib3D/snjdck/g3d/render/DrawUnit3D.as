package snjdck.g3d.render
{
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Matrix3D;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuIndexBuffer;
	import snjdck.gpu.asset.GpuVertexBuffer;
	import snjdck.gpu.register.ConstRegister;
	import snjdck.gpu.register.VertexRegister;
	
	import string.replace;
	
	use namespace ns_g3d;

	final public class DrawUnit3D
	{
		static public const MAX_VA_COUNT:uint = 8;
		static public const MAX_FS_COUNT:uint = 8;
		static public const MAX_VC_COUNT:uint = 128;
		static public const MAX_FC_COUNT:uint = 28;
		
		private var vaSlot:VertexRegister;
		private var vcSlot:ConstRegister;
		private var fcSlot:ConstRegister;
		
		private var worldMatrix:Matrix3D;
		
		public var shaderName:String;
		public var textureName:String;
		
		ns_g3d var indexBuffer:GpuIndexBuffer;
		
		ns_g3d var blendFactor:BlendMode;
		
		private var context3d:GpuContext;
		
		public function DrawUnit3D()
		{
			vaSlot = new VertexRegister(MAX_VA_COUNT);
			vcSlot = new ConstRegister(MAX_VC_COUNT);
			fcSlot = new ConstRegister(MAX_FC_COUNT);
			
			worldMatrix = new Matrix3D();
			
			clear();
		}
		
		ns_g3d function clear():void
		{
			vaSlot.clear();
			vcSlot.clear();
			fcSlot.clear();
			
			worldMatrix.identity();
			
			shaderName = null;
			textureName = null;
			
			indexBuffer = null;
			
			blendFactor = BlendMode.NORMAL;
		}
		
		public function setWorldMatrix(matrix:Matrix3D):void
		{
			worldMatrix.copyFrom(matrix);
			setVcM(4, worldMatrix);
		}
		/*
		public function appendTransformAfterWorldMatrix(matrix:Matrix3D):void
		{
			worldMatrix.append(matrix);
			setVcM(4, worldMatrix);
		}
		*/
		ns_g3d function setVa(slotIndex:int, buffer:GpuVertexBuffer, offset:int=-1, format:String=null):void
		{
			vaSlot.setVa(slotIndex, buffer, offset, format);
		}
		
		ns_g3d function setVa2(buffer:GpuVertexBuffer, formats:Array, fromRegIndex:int=0, fromOffset:int=0):void
		{
			for each(var formatId:int in formats){
				setVa(fromRegIndex++, buffer, fromOffset, VA_FORMAT[formatId]);
				fromOffset += formatId > 0 ? formatId : 1;
			}
		}
		
		public function exec(context3d:GpuContext):void
		{
			this.context3d = context3d;
			
			context3d.setBlendFactor(blendFactor);
			uploadVa();
			uploadProgramConst();
			
			context3d.drawTriangles(indexBuffer);
			
			this.context3d = null;
		}
		
		private function uploadProgramConst():void
		{
			vcSlot.upload(context3d, Context3DProgramType.VERTEX);
			fcSlot.upload(context3d, Context3DProgramType.FRAGMENT);
		}
		
		private function uploadVa():void
		{
			vaSlot.upload(context3d);
		}
		
		ns_g3d function setVcM(firstRegister:int, matrix:Matrix3D):void
		{
			vcSlot.setByMatrix(firstRegister, matrix);
		}
		
		ns_g3d function setVc(firstRegister:int, data:Vector.<Number>, numRegisters:int=-1):void
		{
			vcSlot.setByVector(firstRegister, data, numRegisters);
		}
		
		ns_g3d function setFcM(firstRegister:int, matrix:Matrix3D):void
		{
			fcSlot.setByMatrix(firstRegister, matrix);
		}
		
		ns_g3d function setFc(firstRegister:int, data:Vector.<Number>, numRegisters:int=-1):void
		{
			fcSlot.setByVector(firstRegister, data, numRegisters);
		}
		
		ns_g3d function setBoneMatrix(firstRegister:int, matrix:Matrix3D):void
		{
			vcSlot.setByBone(firstRegister, matrix);
		}
		
		ns_g3d function copyFrom(other:DrawUnit3D):void
		{
			vaSlot.copyFrom(other.vaSlot);
			vcSlot.copyFrom(other.vcSlot);
			fcSlot.copyFrom(other.fcSlot);
			this.shaderName = other.shaderName;
			this.textureName = other.textureName;
			
			worldMatrix.copyFrom(other.worldMatrix);
			
			this.indexBuffer = other.indexBuffer;
			
			this.blendFactor = other.blendFactor;
		}
		
		public function toString():String
		{
			return string.replace("{shader=${0}, texture=${1}}", [shaderName, textureName]);
		}
		
		static private const VA_FORMAT:Vector.<String> = new <String>[
			Context3DVertexBufferFormat.BYTES_4,
			Context3DVertexBufferFormat.FLOAT_1,
			Context3DVertexBufferFormat.FLOAT_2,
			Context3DVertexBufferFormat.FLOAT_3,
			Context3DVertexBufferFormat.FLOAT_4
		];
	}
}