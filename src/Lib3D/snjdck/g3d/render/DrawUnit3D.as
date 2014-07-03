package snjdck.g3d.render
{
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Matrix3D;
	
	import array.copy;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuIndexBuffer;
	import snjdck.gpu.asset.GpuVertexBuffer;
	import snjdck.gpu.BlendMode;
	
	import string.replace;
	
	use namespace ns_g3d;

	final public class DrawUnit3D
	{
		static public const MAX_VA_COUNT:uint = 8;
		static public const MAX_FS_COUNT:uint = 8;
		static public const MAX_VC_COUNT:uint = 128;
		static public const MAX_FC_COUNT:uint = 28;
		
		private var vcUseInfo:Vector.<Boolean>;
		private var fcUseInfo:Vector.<Boolean>;
		
		private var vaSlot:Vector.<GpuVertexBuffer>;
		private var vcSlot:Vector.<Number>;
		private var fcSlot:Vector.<Number>;
		
		private var vaSlotOffset:Vector.<int>;
		private var vaSlotFormat:Vector.<String>;
		
		private var worldMatrix:Matrix3D;
		
		public var shaderName:String;
		public var textureName:String;
		
		ns_g3d var indexBuffer:GpuIndexBuffer;
		
		ns_g3d var blendFactor:BlendMode;
		
		private var context3d:GpuContext;
		
		public function DrawUnit3D()
		{
			vcUseInfo = new Vector.<Boolean>(MAX_VC_COUNT, true);
			fcUseInfo = new Vector.<Boolean>(MAX_FC_COUNT, true);
			
			vaSlot = new Vector.<GpuVertexBuffer>(MAX_VA_COUNT, true);
			vcSlot = new Vector.<Number>(MAX_VC_COUNT * 4 + 4, true);
			fcSlot = new Vector.<Number>(MAX_FC_COUNT * 4, true);
			
			vaSlotOffset = new Vector.<int>(MAX_VA_COUNT, true);
			vaSlotFormat = new Vector.<String>(MAX_VA_COUNT, true);
			
			worldMatrix = new Matrix3D();
			
			clear();
		}
		
		ns_g3d function clear():void
		{
			var i:int;
			
			for(i=0; i<MAX_VA_COUNT; i++){ vaSlot[i] = null; }
			for(i=0; i<MAX_VC_COUNT; i++){ vcUseInfo[i] = false; }
			for(i=0; i<MAX_FC_COUNT; i++){ fcUseInfo[i] = false; }
			
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
			vaSlot[slotIndex] = buffer;
			vaSlotOffset[slotIndex] = offset;
			vaSlotFormat[slotIndex] = format;
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
			setProgramConstImp(Context3DProgramType.VERTEX, vcSlot, vcUseInfo);
			setProgramConstImp(Context3DProgramType.FRAGMENT, fcSlot, fcUseInfo);
		}
		
		private function uploadVa():void
		{
			for(var i:int=0, n:int=vaSlot.length; i<n; i++){
				if(vaSlot[i]){
					context3d.setVertexBufferAt(i, vaSlot[i], vaSlotOffset[i], vaSlotFormat[i]);
				}
			}
		}
		
		private function setProgramConstImp(programType:String, data:Vector.<Number>, useInfo:Vector.<Boolean>):void
		{
			var firstRegister:int;
			var numRegisters:int;
			var flag:Boolean;
			
			for(var i:int=0, n:int=useInfo.length; i<n; i++){
				var test:Boolean = useInfo[i];
				if(flag){
					if(test){
						++numRegisters;
					}
					if(!test || i+1==n){
						context3d.setProgramConstantsFromVector(programType, firstRegister,
							array.copy(data, sharedFloatBuffer, numRegisters*4, firstRegister*4),
							numRegisters
						);
						flag = false;
					}
				}else if(test){
					firstRegister = i;
					numRegisters = 1;
					flag = true;
				}
			}
		}
		
		ns_g3d function setVcM(firstRegister:int, matrix:Matrix3D):void
		{
			setByMatrix(firstRegister, matrix, vcSlot, vcUseInfo);
		}
		
		ns_g3d function setVc(firstRegister:int, data:Vector.<Number>, numRegisters:int=-1):void
		{
			setByVector(firstRegister, data, numRegisters, vcSlot, vcUseInfo);
		}
		
		ns_g3d function setFcM(firstRegister:int, matrix:Matrix3D):void
		{
			setByMatrix(firstRegister, matrix, fcSlot, fcUseInfo);
		}
		
		ns_g3d function setFc(firstRegister:int, data:Vector.<Number>, numRegisters:int=-1):void
		{
			setByVector(firstRegister, data, numRegisters, fcSlot, fcUseInfo);
		}
		
		ns_g3d function setBoneMatrix(firstRegister:int, matrix:Matrix3D):void
		{
			setUseInfo(vcUseInfo, firstRegister, 3);
			
			var index:int = firstRegister * 4;
			var a:Number = vcSlot[index+12], b:Number = vcSlot[index+13], c:Number = vcSlot[index+14], d:Number = vcSlot[index+15];
			matrix.copyRawDataTo(vcSlot, index, true);
			vcSlot[index+12] = a; vcSlot[index+13] = b; vcSlot[index+14] = c; vcSlot[index+15] = d;
		}
		
		private function setByVector(firstRegister:int, data:Vector.<Number>, numRegisters:int, output:Vector.<Number>, useInfo:Vector.<Boolean>):void
		{
			if(-1 == numRegisters){
				numRegisters = Math.ceil(data.length / 4);
			}
			
			setUseInfo(useInfo, firstRegister, numRegisters);
			array.copy(data, output, numRegisters*4, 0, firstRegister*4);
		}
		
		private function setByMatrix(firstRegister:int, matrix:Matrix3D, output:Vector.<Number>, useInfo:Vector.<Boolean>):void
		{
			setUseInfo(useInfo, firstRegister, 4);
			matrix.copyRawDataTo(output, firstRegister * 4, true);
		}
		
		private function setUseInfo(useInfo:Vector.<Boolean>, firstRegister:int, numRegisters:int):void
		{
			for(var i:int=0; i<numRegisters; i++){
				var index:int = firstRegister + i;
				useInfo[index] = true;
			}
		}
		
		ns_g3d function copyFrom(other:DrawUnit3D):void
		{
			var i:int;
			
			for(i=0; i<MAX_VA_COUNT; i++){
				copyVaInfo(other, i);
			}
			
			array.copy(other.vcUseInfo, this.vcUseInfo, MAX_VC_COUNT);
			array.copy(other.vcSlot, this.vcSlot, MAX_VC_COUNT * 4);
			array.copy(other.fcUseInfo, this.fcUseInfo, MAX_FC_COUNT);
			array.copy(other.fcSlot, this.fcSlot, MAX_FC_COUNT * 4);
			
			this.shaderName = other.shaderName;
			this.textureName = other.textureName;
			
			worldMatrix.copyFrom(other.worldMatrix);
			
			this.indexBuffer = other.indexBuffer;
			
			this.blendFactor = other.blendFactor;
		}

		private function copyVaInfo(from:DrawUnit3D, slotIndex:int):void
		{
			this.vaSlot[slotIndex]			= from.vaSlot[slotIndex];
			this.vaSlotOffset[slotIndex]	= from.vaSlotOffset[slotIndex];
			this.vaSlotFormat[slotIndex]	= from.vaSlotFormat[slotIndex];
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
		static private const sharedFloatBuffer:Vector.<Number> = new Vector.<Number>();
	}
}