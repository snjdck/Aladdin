package snjdck.gpu.asset
{
	import flash.display3D.Context3D;
	
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.DepthTest;
	import snjdck.gpu.register.VertexRegister;
	
	import stdlib.guard.GuardValue;
	
	public class GpuContextEx extends GpuContext
	{
		private const programToSet:GuardValue = new GuardValue();
		private const blendModeToSet:GuardValue = new GuardValue();
		private const cullingToSet:GuardValue = new GuardValue();
		
		private var isDepthTestDirty:Boolean;
		private const depthTestToSet:DepthTest = new DepthTest();
		
		private var isVertexRegisterDirty:Boolean;
		private const vertexRegisterToSet:VertexRegister = new VertexRegister();
		private var applyMode:Boolean;
		
		public function GpuContextEx(context3d:Context3D)
		{
			super(context3d);
		}
		
		private function applyChange():void
		{
			if(programToSet.isDirty){
				super.program = programToSet.valueOf();
				programToSet.clear();
			}
			if(isVertexRegisterDirty){
				applyMode = true;
				vertexRegisterToSet.upload(this);
				applyMode = false;
				isVertexRegisterDirty = false;
			}
			if(blendModeToSet.isDirty){
				super.blendMode = blendModeToSet.valueOf();
				blendModeToSet.isDirty = false;
			}
			if(isDepthTestDirty){
				super.setDepthTest(depthTestToSet.writeMask, depthTestToSet.passCompareMode);
				isDepthTestDirty = false;
			}
			if(cullingToSet.isDirty){
				super.setCulling(cullingToSet.valueOf());
				cullingToSet.isDirty = false;
			}
		}
		
		override public function drawTriangles(indexBuffer:GpuIndexBuffer, firstIndex:int=0, numTriangles:int=-1):void
		{
			applyChange();
			super.drawTriangles(indexBuffer, firstIndex, numTriangles);
		}
		
		override protected function getProgram():GpuProgram
		{
			return programToSet.getValue(super.getProgram());
		}
		
		override public function set program(value:GpuProgram):void
		{
			programToSet.setValue(value, super.getProgram());
			vertexRegisterToSet.onProgramChanged(value);
		}
		
		override protected function getBlendMode():BlendMode
		{
			return blendModeToSet.getValue(super.getBlendMode());
		}
		
		override public function set blendMode(value:BlendMode):void
		{
			blendModeToSet.setValue(value, super.getBlendMode());
		}
		
		override protected function getDepthTest():DepthTest
		{
			return isDepthTestDirty ? depthTestToSet : super.getDepthTest();
		}
		
		override public function setDepthTest(depthMask:Boolean, passCompareMode:String):void
		{
			var isEqual:Boolean = super.getDepthTest().equals(depthMask, passCompareMode);
			if(isDepthTestDirty){
				if(isEqual){
					isDepthTestDirty = false;
				}
			}else if(!isEqual){
				isDepthTestDirty = true;
			}
			depthTestToSet.setTo(depthMask, passCompareMode);
		}
		
		override protected function getCulling():String
		{
			return cullingToSet.getValue(super.getCulling());
		}
		
		override public function setCulling(value:String):void
		{
			cullingToSet.setValue(value, super.getCulling());
		}
		
		override protected function getVertexRegister():VertexRegister
		{
			return vertexRegisterToSet;
		}
		
		override public function setVertexBufferAt(slotIndex:int, buffer:GpuVertexBuffer, bufferOffset:int, format:String):void
		{
			if(applyMode){
				super.setVertexBufferAt(slotIndex, buffer, bufferOffset, format);
			}else{
				isVertexRegisterDirty = true;
				vertexRegisterToSet.setVa(slotIndex, buffer, bufferOffset, format);
			}
		}
	}
}