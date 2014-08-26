package snjdck.gpu.asset
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DClearMask;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DStencilAction;
	import flash.display3D.Context3DTriangleFace;
	import flash.geom.Rectangle;
	
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.register.ConstRegister;
	import snjdck.gpu.register.FragmentRegister;
	import snjdck.gpu.register.VertexRegister;

	final public class GpuContext
	{
		static public const MAX_VA_COUNT:uint = 8;
		static public const MAX_FS_COUNT:uint = 8;
		static public const MAX_VC_COUNT:uint = 128;
		static public const MAX_FC_COUNT:uint = 28;
		
		private var context3d:Context3D;
		
		private var blendMode:BlendMode;
		
		private var depthWriteMask:Boolean;
		private var depthPassCompareMode:String;
		
		/** readMask, writeMask, refValue */
		private var stencilRefValue:int;
		
		private var currentProgram:GpuProgram;
		private var vaUseInfo:uint;
		private var fsUseInfo:uint;
		
		private var currentRenderTarget:GpuRenderTarget;
		private var backBufferWidth:int;
		private var backBufferHeight:int;
		
		private var vaReg:VertexRegister;
		private var fsReg:FragmentRegister;
		private var vcReg:ConstRegister;
		private var fcReg:ConstRegister;
		
		public function GpuContext(context3d:Context3D)
		{
			this.context3d = context3d;
			
			blendMode = BlendMode.NORMAL;
			
			depthWriteMask = true;
			depthPassCompareMode = Context3DCompareMode.LESS_EQUAL;
			
			stencilRefValue = 0xFFFF00;
			
			vcReg = new ConstRegister(MAX_VC_COUNT, Context3DProgramType.VERTEX);
			fcReg = new ConstRegister(MAX_FC_COUNT, Context3DProgramType.FRAGMENT);
			vaReg = new VertexRegister(MAX_VA_COUNT);
			fsReg = new FragmentRegister(MAX_FS_COUNT);
		}
		
		public function get driverInfo():String
		{
			return context3d.driverInfo;
		}
		
		public function get enableErrorChecking():Boolean
		{
			return context3d.enableErrorChecking;
		}
		
		public function set enableErrorChecking(value:Boolean):void
		{
			context3d.enableErrorChecking = value;
		}
		
		public function dispose():void
		{
			context3d.dispose();
		}
		
		public function configureBackBuffer(width:int, height:int, antiAlias:int):void
		{
			context3d.configureBackBuffer(width, height, antiAlias, true);
			backBufferWidth = width;
			backBufferHeight = height;
		}
		
		public function clear(red:Number=0.0, green:Number=0.0, blue:Number=0.0, alpha:Number=1.0, depth:Number=1.0, stencil:uint=0, mask:uint=0xFFFFFFFF):void
		{
			context3d.clear(red, green, blue, alpha, depth, stencil, mask);
		}
		
		public function present():void
		{
			context3d.present();
		}
		
		public function setColorMask(red:Boolean, green:Boolean, blue:Boolean, alpha:Boolean):void
		{
			context3d.setColorMask(red, green, blue, alpha);
		}
		
		public function setCulling(triangleFaceToCull:String):void
		{
			context3d.setCulling(triangleFaceToCull);
		}
		
		public function setBlendFactor(value:BlendMode):void
		{
			if(!blendMode.equals(value)){
				blendMode = value;
				context3d.setBlendFactors(blendMode.sourceFactor, blendMode.destinationFactor);
			}
		}
		
		public function setScissorRect(rect:Rectangle):void
		{
			context3d.setScissorRectangle(rect);
		}
		
		public function setDepthTest(depthMask:Boolean, passCompareMode:String):void
		{
			if(depthMask != depthWriteMask || passCompareMode != depthPassCompareMode){
				depthWriteMask = depthMask;
				depthPassCompareMode = passCompareMode;
				context3d.setDepthTest(depthWriteMask, depthPassCompareMode);
			}
		}
		
		/** if stencilReference OPERATOR stencilBuffer then pass) */
		public function setStencilActions(triangleFace:String=Context3DTriangleFace.FRONT_AND_BACK,
			compareMode:String=Context3DCompareMode.ALWAYS,
			actionOnBothPass:String=Context3DStencilAction.KEEP,
			actionOnDepthFail:String=Context3DStencilAction.KEEP,
			actionOnDepthPassStencilFail:String=Context3DStencilAction.KEEP
		):void
		{
			context3d.setStencilActions(triangleFace, compareMode, actionOnBothPass, actionOnDepthFail, actionOnDepthPassStencilFail);
		}
		
		public function setStencilReferenceValue(refValue:uint, readMask:uint=0xFF, writeMask:uint=0xFF):void
		{
			var newValue:int = (refValue & 0xFF) | ((readMask & 0xFF) << 16) | ((writeMask & 0xFF) << 8);
			if(newValue != stencilRefValue){
				stencilRefValue = newValue;
				context3d.setStencilReferenceValue(refValue, readMask, writeMask);
			}
		}
		
		public function setRenderToTexture(renderTarget:GpuRenderTarget):void
		{
			context3d.setRenderToTexture(
				renderTarget.getRawGpuAsset(context3d), true,
				renderTarget.antiAlias, 0, 0
			);
		}
		
		public function setRenderToBackBuffer():void
		{
			context3d.setRenderToBackBuffer();
		}
		
		public function setVc(firstRegister:int, data:Vector.<Number>, numRegisters:int=-1):void
		{
			vcReg.setByVector(firstRegister, data, numRegisters);
		}
		
		public function setFc(firstRegister:int, data:Vector.<Number>, numRegisters:int=-1):void
		{
			fcReg.setByVector(firstRegister, data, numRegisters);
		}
		
		public function setVcReg(constReg:ConstRegister):void
		{
			vcReg.merge(constReg);
		}
		
		public function setFcReg(constReg:ConstRegister):void
		{
			fcReg.merge(constReg);
		}
		
		public function setVaReg(reg:VertexRegister):void
		{
			vaReg.merge(reg);
		}
		
		public function setProgram(program:GpuProgram):void
		{
			if(program == currentProgram){
				return;
			}
			
			context3d.setProgram(program.getRawGpuAsset(context3d));
			currentProgram = program;
			
			unsetInputs(vaUseInfo & ~program.getVaUseInfo(), "setVertexBufferAt");
			unsetInputs(fsUseInfo & ~program.getFsUseInfo(), "setTextureAt");
			
			vaUseInfo = program.getVaUseInfo();
			fsUseInfo = program.getFsUseInfo();
		}
		
		private function unsetInputs(useInfo:uint, methodName:String):void
		{
			var slotIndex:int = 0;
			while(useInfo > 0){
				if(useInfo & 1){
					context3d[methodName](slotIndex, null);
				}
				useInfo >>>= 1;
				++slotIndex;
			}
		}
		
		public function setVertexBufferAt(slotIndex:int, buffer:GpuVertexBuffer, bufferOffset:int, format:String):void
		{
			vaReg.setVa(slotIndex, buffer, bufferOffset, format);
		}
		
		public function setTextureAt(slotIndex:int, texture:IGpuTexture):void
		{
			fsReg.setFs(slotIndex, texture);
		}
		
		public function drawTriangles(indexBuffer:GpuIndexBuffer, firstIndex:int=0, numTriangles:int=-1):void
		{
			vcReg.upload(context3d);vcReg.clear();
			fcReg.upload(context3d);fcReg.clear();
			vaReg.upload(context3d);vaReg.clear();
			fsReg.upload(context3d);fsReg.clear();
			context3d.drawTriangles(indexBuffer.getRawGpuAsset(context3d), firstIndex, numTriangles);
		}
		
		public function isVaSlotInUse(slotIndex:int):Boolean
		{
			return (vaUseInfo & (1 << slotIndex)) != 0;
		}
		
		public function clearDepthAndStencil():void
		{
			context3d.clear(0.0, 0.0, 0.0, 1.0, 1.0, 0, Context3DClearMask.DEPTH | Context3DClearMask.STENCIL);
		}
		
		public function get bufferWidth():int
		{
			if(null == currentRenderTarget){
				return backBufferWidth;
			}
			return currentRenderTarget.width;
		}
		
		public function get bufferHeight():int
		{
			if(null == currentRenderTarget){
				return backBufferHeight;
			}
			return currentRenderTarget.height;
		}
	}
}