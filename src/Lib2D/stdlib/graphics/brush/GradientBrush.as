package stdlib.graphics.brush
{
	import stdlib.graphics.IBrush;
	
	import flash.display.Graphics;
	import flash.geom.Matrix;

	public class GradientBrush implements IBrush
	{
		static private const DEFAULT_ALPHAS:Array = [1, 1];
		static private const DEFAULT_RATIOS:Array = [0, 255];
		
		private var type:String;
		private var colors:Array;
		private var alphas:Array;
		private var ratios:Array;
		private var matrix:Matrix;
		/*
		private var spreadMethod:String = "pad";
		private var interpolationMethod:String = "rgb";
		private var focalPointRatio:Number = 0;
		//*/
		
		public function GradientBrush(type:String, colors:Array, alphas:Array, ratios:Array, width:Number, height:Number, rotation:Number=0, tx:Number=0, ty:Number=0)
		{
			this.type = type;
			this.colors = colors;
			this.alphas = alphas || DEFAULT_ALPHAS;
			this.ratios = ratios || DEFAULT_RATIOS;
			
			this.matrix = new Matrix();
			this.matrix.createGradientBox(width, height, rotation, tx, ty);
			/*
			this.spreadMethod = spreadMethod;
			this.interpolationMethod = interpolationMethod;
			this.focalPointRatio = focalPointRatio;
			//*/
		}
		
		public function beginFill(target:Graphics):void
		{
			target.beginGradientFill(type, colors, alphas, ratios, matrix);
		}
	}
}