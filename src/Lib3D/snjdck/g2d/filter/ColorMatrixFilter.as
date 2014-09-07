package snjdck.g2d.filter
{
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuRenderTarget;
	import snjdck.gpu.asset.IGpuTexture;
	import snjdck.gpu.asset.helper.AssetMgr;
	import snjdck.gpu.asset.helper.ShaderName;
	import snjdck.gpu.render.GpuRender;

	public class ColorMatrixFilter extends Filter2D
	{
		static public const grayMatrix:Vector.<Number> = new <Number>[
			0.299, 0.587, 0.114, 0,
			0.299, 0.587, 0.114, 0,
			0.299, 0.587, 0.114, 0,
			0, 0, 0, 1,
			0, 0, 0, 0
		];
		
		private var _matrix:Vector.<Number>;
		
		public function ColorMatrixFilter(matrix:Vector.<Number>)
		{
			_matrix = matrix;
		}
		
		override public function renderFilter(texture:IGpuTexture, render:GpuRender, context3d:GpuContext, output:GpuRenderTarget, textureX:Number, textureY:Number):void
		{
			context3d.renderTarget = output;
			context3d.program = AssetMgr.Instance.getProgram(ShaderName.COLOR_MATRIX);
			context3d.setFc(0, _matrix, 5);
			render.r2d.drawTexture(context3d, texture, textureX, textureY);
		}
	}
}