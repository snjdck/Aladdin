package snjdck.g2d.support
{
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuIndexBuffer;
	import snjdck.gpu.asset.IGpuTexture;

	internal class RenderStateBatch
	{
		private var stateList:Vector.<RenderState> = new Vector.<RenderState>();
		private var stateCount:int;
		
		public function RenderStateBatch(){}
		
		public function add(texture:IGpuTexture):void
		{
			if(stateList.length <= stateCount){
				stateList.push(new RenderState());
			}
			var currentState:RenderState;
			if(stateCount > 0){
				currentState = stateList[stateCount-1];
				if(texture == currentState.texture){
					++currentState.quadCount;
					return;
				}
			}
			currentState = stateList[stateCount];
			currentState.texture = texture;
			currentState.quadCount = 1;
			++stateCount;
		}
		
		public function draw(context3d:GpuContext, indexBuffer:GpuIndexBuffer):void
		{
			var offset:int = 0;
			for(var i:int=0; i<stateCount; i++){
				var state:RenderState = stateList[i];
				context3d.setTextureAt(0, state.texture);
				context3d.drawTriangles(indexBuffer, offset * 6, state.quadCount << 1);
				offset += state.quadCount;
			}
		}
		
		public function clear():void
		{
			for each(var state:RenderState in stateList){
				state.texture = null;
			}
			stateCount = 0;
		}
	}
}

import snjdck.gpu.asset.IGpuTexture;

class RenderState
{
	public var texture:IGpuTexture;
	public var quadCount:int;
}