package snjdck.gpu.asset
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DClearMask;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DStencilAction;
	import flash.display3D.Context3DTriangleFace;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.state.GpuStateStack;

	public class GpuContext
	{
		private var context3d:Context3D;
		
		private var _backBufferWidth:int;
		private var _backBufferHeight:int;
		
		private var _blendMode:BlendMode;
		
		protected var depthWriteMask:Boolean;
		protected var depthPassCompareMode:String;
		
		protected var culling:String;
		
		/** readMask, writeMask, refValue */
		private var stencilRefValue:int;
		
		private var _program:GpuProgram;
		
		private var _texture:IGpuTexture;
		
		private var _renderTarget:GpuRenderTarget;
		
		private var stateStack:GpuStateStack;
		
		private const garbageCollector:AssetGC = new AssetGC();
		
		public function GpuContext(context3d:Context3D)
		{
			this.context3d = context3d;
			
			_blendMode = BlendMode.NORMAL;
			
			depthWriteMask = true;
			depthPassCompareMode = Context3DCompareMode.LESS_EQUAL;
			
			culling = Context3DTriangleFace.NONE;
			
			stencilRefValue = 0xFFFF00;
			
			stateStack = new GpuStateStack();
		}
		
		public function dispose():void
		{
			context3d.dispose();
		}
		
		public function configureBackBuffer(width:int, height:int, antiAlias:int):void
		{
			context3d.configureBackBuffer(width, height, antiAlias, true);
			_backBufferWidth = width;
			_backBufferHeight = height;
		}
		
		public function clear(red:Number=0.0, green:Number=0.0, blue:Number=0.0, alpha:Number=1.0, depth:Number=1.0, stencil:uint=0, mask:uint=0xFFFFFFFF):void
		{
			context3d.clear(red, green, blue, alpha, depth, stencil, mask);
			if(_renderTarget != null){
				_renderTarget._hasCleared = true;
			}
		}
		
		public function present():void
		{
			context3d.present();
		}
		
		public function setColorMask(red:Boolean, green:Boolean, blue:Boolean, alpha:Boolean):void
		{
			context3d.setColorMask(red, green, blue, alpha);
		}
		
		/** 顺时针为front */
		public function setCulling(triangleFaceToCull:String):void
		{
			if(triangleFaceToCull != culling){
				context3d.setCulling(triangleFaceToCull);
				culling = triangleFaceToCull;
			}
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
				_renderTarget.getRawGpuAsset(context3d),
				_renderTarget.enableDepthAndStencil,
				_renderTarget.antiAlias, 0
			);
		}
		
		public function setVc(firstRegister:int, data:Vector.<Number>, numRegisters:int=-1):void
		{
			context3d.setProgramConstantsFromVector(Context3DProgramType.VERTEX, firstRegister, data, numRegisters);
		}
		
		public function setVcM(firstRegister:int, matrix:Matrix3D):void
		{
			context3d.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, firstRegister, matrix, true);
		}
		
		public function setFc(firstRegister:int, data:Vector.<Number>, numRegisters:int=-1):void
		{
			context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, firstRegister, data, numRegisters);
		}
		
		public function setFcM(firstRegister:int, matrix:Matrix3D):void
		{
			context3d.setProgramConstantsFromMatrix(Context3DProgramType.FRAGMENT, firstRegister, matrix, true);
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
			
			value.unsetInputs(_program, context3d);
			
			_program = value;
			context3d.setProgram(_program.getRawGpuAsset(context3d));
			
			if(!isFsSlotInUse(0) && _texture != null){
				_texture = null;
			}
		}
		
		public function setVertexBufferAt(slotIndex:int, buffer:GpuVertexBuffer, bufferOffset:int, format:String):void
		{
			context3d.setVertexBufferAt(slotIndex, buffer.getRawGpuAsset(context3d), bufferOffset, format);
		}
		
		public function set texture(value:IGpuTexture):void
		{
			setTextureAt(0, value);
		}
		
		public function setTextureAt(slotIndex:int, texture:IGpuTexture):void
		{
			if(0 == slotIndex){
				if(_texture == texture){
					return;
				}else{
					_texture = texture;
				}
			}
			context3d.setTextureAt(slotIndex, texture.getRawGpuAsset(context3d));
		}
		
		public function drawTriangles(indexBuffer:GpuIndexBuffer, firstIndex:int=0, numTriangles:int=-1):void
		{
			context3d.drawTriangles(indexBuffer.getRawGpuAsset(context3d), firstIndex, numTriangles);
		}
		
		public function isVaSlotInUse(slotIndex:int):Boolean
		{
			return _program.isVaSlotInUse(slotIndex);
		}
		
		public function isFsSlotInUse(slotIndex:int):Boolean
		{
			return _program.isFsSlotInUse(slotIndex);
		}
		
		public function clearDepthAndStencil(depth:Number=1.0, stencil:uint=0):void
		{
			clear(0.0, 0.0, 0.0, 1.0, depth, stencil, Context3DClearMask.DEPTH | Context3DClearMask.STENCIL);
		}
		
		public function clearDepth(depth:Number=1.0):void
		{
			clear(0.0, 0.0, 0.0, 1.0, depth, 0, Context3DClearMask.DEPTH);
		}
		
		public function clearStencil(stencil:uint=0):void
		{
			clear(0.0, 0.0, 0.0, 1.0, 1.0, stencil, Context3DClearMask.STENCIL);
		}
		
		public function get backBufferWidth():int
		{
			return _backBufferWidth;
		}
		
		public function get backBufferHeight():int
		{
			return _backBufferHeight;
		}
		
		public function get bufferWidth():int
		{
			if(null == _renderTarget){
				return _backBufferWidth;
			}
			return _renderTarget.width;
		}
		
		public function get bufferHeight():int
		{
			if(null == _renderTarget){
				return _backBufferHeight;
			}
			return _renderTarget.height;
		}
		
		public function isRectInBuffer(rect:Rectangle):Boolean
		{
			return !(rect.x >= bufferWidth || rect.y >= bufferHeight || rect.right <= 0 || rect.bottom <= 0);
		}
		
		public function save():void
		{
			stateStack.save(this);
		}
		
		public function restore():void
		{
			stateStack.restore(this);
		}
		
		public function markRecoverableGpuAsset(asset:IGpuAsset):void
		{
			garbageCollector.addRef(asset);
		}
		
		public function gc():void
		{
			garbageCollector.gc();
		}
	}
}