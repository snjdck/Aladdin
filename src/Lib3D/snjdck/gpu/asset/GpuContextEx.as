package snjdck.gpu.asset
{
	import flash.display3D.Context3D;
	
	import snjdck.gpu.BlendMode;
	
	public class GpuContextEx extends GpuContext
	{
		private var isProgramDirty:Boolean;
		private var programToSet:GpuProgram;
	
		private var isBlendModeDirty:Boolean;
		private var blendModeToSet:BlendMode;
		
		private var isDepthTestDirty:Boolean;
		private var depthWriteMaskToSet:Boolean;
		private var depthPassCompareModeToSet:String;
		
		private var isCullingDirty:Boolean;
		private var cullingToSet:String;
		
		private var isVertexBufferDirty:Boolean;
		private var vertexBufferToSet:Array = [];
		
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
			if(isVertexBufferDirty){
				for each(var argList:Array in vertexBufferToSet){
					if(argList != null && isVaSlotInUse(argList[0])){
						super.setVertexBufferAt.apply(this, argList);
					}
				}
				isVertexBufferDirty = false;
				vertexBufferToSet.length = 0;
			}
			if(isBlendModeDirty){
				super.blendMode = blendModeToSet;
				isBlendModeDirty = false;
				blendModeToSet = null;
			}
			if(isDepthTestDirty){
				super.setDepthTest(depthWriteMaskToSet, depthPassCompareModeToSet);
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
		
		override public function get program():GpuProgram
		{
			return isProgramDirty ? programToSet : super.program;
		}
		
		override public function set program(value:GpuProgram):void
		{
			if(isProgramDirty){
				if(value == super.program){
					isProgramDirty = false;
					programToSet = null;
				}else if(value != programToSet){
					programToSet = value;
				}
			}else if(value != super.program){
				isProgramDirty = true;
				programToSet = value;
			}
		}
		
		override public function get blendMode():BlendMode
		{
			return isBlendModeDirty ? blendModeToSet : super.blendMode;
		}
		
		override public function set blendMode(value:BlendMode):void
		{
			if(isBlendModeDirty){
				if(value == super.blendMode){
					isBlendModeDirty = false;
				}
			}else if(value != super.blendMode){
				isBlendModeDirty = true;
			}
			blendModeToSet = value;
		}
		
		override public function setDepthTest(depthMask:Boolean, passCompareMode:String):void
		{
			if(isDepthTestDirty){
				if(depthMask == depthWriteMask && passCompareMode == depthPassCompareMode){
					isDepthTestDirty = false;
				}
			}else if(depthMask != depthWriteMask || passCompareMode != depthPassCompareMode){
				isDepthTestDirty = true;
			}
			depthWriteMaskToSet = depthMask;
			depthPassCompareModeToSet = passCompareMode;
		}
		
		override public function setCulling(value:String):void
		{
			if(isCullingDirty){
				if(value == culling){
					isCullingDirty = false;
				}
			}else if(value != culling){
				isCullingDirty = true;
			}
			cullingToSet = value;
		}
		
		override public function setVertexBufferAt(slotIndex:int, buffer:GpuVertexBuffer, bufferOffset:int, format:String):void
		{
			isVertexBufferDirty = true;
			vertexBufferToSet[slotIndex] = arguments;
		}
	}
}