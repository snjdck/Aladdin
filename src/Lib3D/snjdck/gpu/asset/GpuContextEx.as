package snjdck.gpu.asset
{
	import flash.display3D.Context3D;
	
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.DepthTest;
	
	public class GpuContextEx extends GpuContext
	{
		private var isProgramDirty:Boolean;
		private var programToSet:GpuProgram;
	
		private var isBlendModeDirty:Boolean;
		private var blendModeToSet:BlendMode;
		
		private var isDepthTestDirty:Boolean;
		private const depthTestToSet:DepthTest = new DepthTest();
		
		private var isCullingDirty:Boolean;
		private var cullingToSet:String;
		
		public function GpuContextEx(context3d:Context3D)
		{
			super(context3d);
		}
		
		private function applyChange():void
		{
			if(isProgramDirty){
				super.program = programToSet;
				isProgramDirty = false;
				programToSet = null;
			}
			if(isBlendModeDirty){
				super.blendMode = blendModeToSet;
				isBlendModeDirty = false;
			}
			if(isDepthTestDirty){
				super.setDepthTest(depthTestToSet.writeMask, depthTestToSet.passCompareMode);
				isDepthTestDirty = false;
			}
			if(isCullingDirty){
				super.setCulling(cullingToSet);
				isCullingDirty = false;
			}
		}
		
		override public function drawTriangles(indexBuffer:GpuIndexBuffer, firstIndex:int=0, numTriangles:int=-1):void
		{
			applyChange();
			super.drawTriangles(indexBuffer, firstIndex, numTriangles);
		}
		
		override protected function getProgram():GpuProgram
		{
			return isProgramDirty ? programToSet : super.getProgram();
		}
		
		override public function set program(value:GpuProgram):void
		{
			if(isProgramDirty){
				if(value == super.getProgram()){
					isProgramDirty = false;
					programToSet = null;
				}else if(value != programToSet){
					programToSet = value;
				}
			}else if(value != super.getProgram()){
				isProgramDirty = true;
				programToSet = value;
			}
			vertexRegister.onProgramChanged(value);
		}
		
		override protected function getBlendMode():BlendMode
		{
			return isBlendModeDirty ? blendModeToSet : super.getBlendMode();
		}
		
		override public function set blendMode(value:BlendMode):void
		{
			if(isBlendModeDirty){
				if(value == super.getBlendMode()){
					isBlendModeDirty = false;
				}
			}else if(value != super.getBlendMode()){
				isBlendModeDirty = true;
			}
			blendModeToSet = value;
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
			return isCullingDirty ? cullingToSet : super.getCulling();
		}
		
		override public function setCulling(value:String):void
		{
			if(isCullingDirty){
				if(value == super.getCulling()){
					isCullingDirty = false;
				}
			}else if(value != super.getCulling()){
				isCullingDirty = true;
			}
			cullingToSet = value;
		}
	}
}