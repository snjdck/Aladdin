package f2d
{
	import flash.display.DisplayObject;
	import flash.geom.Matrix;

	public function zoom(target:DisplayObject, zoom:Number, lockArea:Boolean=false):void
	{
		const offsetX:Number = target.parent.mouseX;
		const offsetY:Number = target.parent.mouseY;
		
		const multi:Number = zoom / target.scaleX;
		
		matrix.identity();
		matrix.translate(-offsetX, -offsetY);
		matrix.scale(multi, multi);
		matrix.translate(offsetX, offsetY);
		
		const prevMatrix:Matrix = target.transform.matrix;
		prevMatrix.concat(matrix);
		target.transform.matrix = prevMatrix;
		
		if(!lockArea){
			return;
		}
		
		if(target.x > 0){
			target.x = 0;
		}
		
		if(target.y > 0){
			target.y = 0;
		}
		
		if(target.x + target.width < target.stage.stageWidth){
			target.x = target.stage.stageWidth - target.width;
		}
		
		if(target.y + target.height < target.stage.stageHeight){
			target.y = target.stage.stageHeight - target.height;
		}
	}
}

import flash.geom.Matrix;

const matrix:Matrix = new Matrix();