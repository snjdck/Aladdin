package snjdck.g2d.filter
{
	import snjdck.g2d.ns_g2d;
	import snjdck.g2d.core.IFilter2D;
	import snjdck.g2d.impl.DisplayObject2D;
	import snjdck.g2d.render.Render2D;
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.asset.AssetMgr;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuRenderTarget;
	import snjdck.gpu.asset.IGpuTexture;
	import snjdck.shader.ShaderName;
	
	use namespace ns_g2d;

	public class FilterGroup2D extends Filter2D
	{
		private var _filterList:Vector.<IFilter2D>;
		private var _marginX:Number = 0;
		private var _marginY:Number = 0;
		
		public function FilterGroup2D()
		{
			_filterList = new Vector.<IFilter2D>();
		}
		
		public function addFilter(filter:IFilter2D):void
		{
			_filterList.push(filter);
			_marginX = Math.max(_marginX, filter.marginX);
			_marginX = Math.max(_marginY, filter.marginY);
		}
		
		override public function draw(target:DisplayObject2D, render:Render2D, context3d:GpuContext):void
		{
			switch(_filterList.length)
			{
				case 0:
					target.draw(render, context3d);
					break;
				case 1:
					var filter:IFilter2D = _filterList[0];
					filter.draw(target, render, context3d);
					break;
				default:
					super.draw(target, render, context3d);
			}
		}
		
		override public function renderFilter(texture:IGpuTexture, render:Render2D, context3d:GpuContext, output:GpuRenderTarget, textureX:Number, textureY:Number):void
		{
			switch(_filterList.length)
			{
				case 0:
					context3d.renderTarget = output;
					context3d.program = AssetMgr.Instance.getProgram(ShaderName.IMAGE);
					render.drawTexture(context3d, texture, textureX, textureY);
					break;
				case 1:
					var filter:IFilter2D = _filterList[0];
					filter.renderFilter(texture, render, context3d, output, textureX, textureY);
					break;
				default:
					renderFilterImpl(texture, render, context3d, output, textureX, textureY);
			}
		}
		
		private function renderFilterImpl(texture:IGpuTexture, render:Render2D, context3d:GpuContext, output:GpuRenderTarget, textureX:Number, textureY:Number):void
		{
			const filterCount:int = _filterList.length;
//			const prevBlendMode:BlendMode = context3d.blendMode;
			context3d.blendMode = BlendMode.NORMAL;
			
			var backBuffer:GpuRenderTarget = new GpuRenderTarget(texture.width, texture.height);
			var frontBuffer:GpuRenderTarget;
			
			if(filterCount > 2){
				frontBuffer = new GpuRenderTarget(texture.width, texture.height);
			}
			
			render.pushScreen(texture.width, texture.height);
			
			for(var i:int=0; i<filterCount; i++){
				const swapTemp:GpuRenderTarget = frontBuffer;
				frontBuffer = backBuffer;
				backBuffer = swapTemp;
				const filter:IFilter2D = _filterList[i];
				if(i + 1 < filterCount){
					context3d.renderTarget = frontBuffer;
					context3d.clearStencil();
					const gpuTexture:IGpuTexture = (i == 0 ? texture : backBuffer);
					filter.renderFilter(gpuTexture, render, context3d, frontBuffer, 0, 0);
				}else{
					render.popScreen();
//					context3d.blendMode = prevBlendMode;
					filter.renderFilter(backBuffer, render, context3d, output, textureX, textureY);
				}
			}
			
			if(frontBuffer != null){
				frontBuffer.dispose();
			}
			backBuffer.dispose();
		}
		
		override public function get marginX():int
		{
			return _marginX;
		}
		
		override public function get marginY():int
		{
			return _marginY;
		}
	}
}