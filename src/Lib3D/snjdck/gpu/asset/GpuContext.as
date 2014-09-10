package snjdck.gpu.asset
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DClearMask;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DStencilAction;
	import flash.display3D.Context3DTriangleFace;
	import flash.geom.Rectangle;
	
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.register.ConstRegister;

	final public class GpuContext
	{
		private var context3d:Context3D;
		
		private var _blendMode:BlendMode;
		
		private var depthWriteMask:Boolean;
		private var depthPassCompareMode:String;
		
		/** readMask, writeMask, refValue */
		private var stencilRefValue:int;
		
		private var _program:GpuProgram;
		private var vaUseInfo:uint;
		private var fsUseInfo:uint;
		
		private var _renderTarget:GpuRenderTarget;
		
		private var vcReg:ConstRegister;
		private var fcReg:ConstRegister;
		
		public function GpuContext(context3d:Context3D)
		{
			this.context3d = context3d;
			
			_blendMode = BlendMode.NORMAL;
			
			depthWriteMask = true;
			depthPassCompareMode = Context3DCompareMode.LESS_EQUAL;
			
			stencilRefValue = 0xFFFF00;
			
			vcReg = ConstRegister.NewVertexConstRegister();
			fcReg = ConstRegister.NewFragmentConstRegister();
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
		
		public function get blendMode():BlendMode
		{
			return _blendMode;
		}
		
		public function set blendMode(value:BlendMode):void
		{
			if(_blendMode.equals(value)){
				return;
			}
			_blendMode = value;
			_blendMode.apply(context3d);
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
		
		public function get renderTarget():GpuRenderTarget
		{
			return _renderTarget;
		}
		
		public function set renderTarget(value:GpuRenderTarget):void
		{
			setRenderToTexture(value, 0);
		}
		
		public function setRenderToTexture(texture:GpuRenderTarget, colorOutputIndex:int):void
		{
			if(_renderTarget == texture){
				return;
			}
			_renderTarget = texture;
			if(null == _renderTarget){
				context3d.setRenderToBackBuffer();
				return;
			}
			context3d.setRenderToTexture(
				_renderTarget.getRawGpuAsset(context3d), true,
				_renderTarget.antiAlias, 0, colorOutputIndex
			);
		}
		
		public function setRenderToBackBuffer():void
		{
			if(null == _renderTarget){
				return;
			}
			context3d.setRenderToBackBuffer();
			_renderTarget = null;
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
		
		public function get program():GpuProgram
		{
			return _program;
		}
		
		public function set program(value:GpuProgram):void
		{
			if(value == _program){
				return;
			}
			
			_program = value;
			context3d.setProgram(_program.getRawGpuAsset(context3d));
			
			unsetInputs(vaUseInfo & ~_program.getVaUseInfo(), "setVertexBufferAt");
			unsetInputs(fsUseInfo & ~_program.getFsUseInfo(), "setTextureAt");
			
			vaUseInfo = _program.getVaUseInfo();
			fsUseInfo = _program.getFsUseInfo();
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
			context3d.setVertexBufferAt(slotIndex, buffer.getRawGpuAsset(context3d), bufferOffset, format);
		}
		
		public function setTextureAt(slotIndex:int, texture:IGpuTexture):void
		{
			context3d.setTextureAt(slotIndex, texture.getRawGpuAsset(context3d));
		}
		
		public function drawTriangles(indexBuffer:GpuIndexBuffer, firstIndex:int=0, numTriangles:int=-1):void
		{
			vcReg.upload(context3d);vcReg.clear();
			fcReg.upload(context3d);fcReg.clear();
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
			if(null == _renderTarget){
				return context3d.backBufferWidth;
			}
			return _renderTarget.width;
		}
		
		public function get bufferHeight():int
		{
			if(null == _renderTarget){
				return context3d.backBufferHeight;
			}
			return _renderTarget.height;
		}
	}
}