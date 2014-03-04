package flash.display
{
	import flash.geom.Point;
	import flash.graphics.Graphics2D;
	import flash.graphics.IPath;
	import flash.graphics.brush.SolidBrush;
	import flash.graphics.path.Path;
	import flash.graphics.pen.SolidPen;
	
	import snjdck.common.geom.Rect2D;
	
	import stdlib.constant.Direction;
	
	import string.has;

	final public class ToolTipDrawer
	{
		static public function CreateInfoTipPath(width:Number, height:Number, thumbDir:String):IPath
		{
			const thumbSize:Number = 5;
			var path:Path = new Path();
			
			//左上点
			if(Direction.TOP_LEFT == thumbDir){
				path.moveTo(thumbSize, 0);
				path.lineTo(-thumbSize, -thumbSize);
				path.lineTo(0, thumbSize);
			}else{
				path.moveTo(0, 0);
			}
			
			if(Direction.LEFT == thumbDir){
				path.lineTo(0, height*0.5-thumbSize);
				path.lineTo(-thumbSize*2, height*0.5);
				path.lineTo(0, height*0.5+thumbSize);
			}
			
			//左下点
			if(Direction.BOTTOM_LEFT == thumbDir){
				path.lineTo(0, height-thumbSize);
				path.lineTo(-thumbSize, height+thumbSize);
				path.lineTo(thumbSize, height);
			}else{
				path.lineTo(0, height);
			}
			
			if(Direction.BOTTOM == thumbDir){
				path.lineTo(width*0.5-thumbSize, height);
				path.lineTo(width*0.5, height+thumbSize*2);
				path.lineTo(width*0.5+thumbSize, height);
			}
			
			//右下点
			if(Direction.BOTTOM_RIGHT == thumbDir){
				path.lineTo(width-thumbSize, height);
				path.lineTo(width+thumbSize, height+thumbSize);
				path.lineTo(width, height-thumbSize);
			}else{
				path.lineTo(width, height);
			}
			
			if(Direction.RIGHT == thumbDir){
				path.lineTo(width, height*0.5+thumbSize);
				path.lineTo(width+thumbSize*2, height*0.5);
				path.lineTo(width, height*0.5-thumbSize);
			}
			
			//右上点
			if(Direction.TOP_RIGHT == thumbDir){
				path.lineTo(width, thumbSize);
				path.lineTo(width+thumbSize, -thumbSize);
				path.lineTo(width-thumbSize, 0);
			}else{
				path.lineTo(width, 0);
			}
			
			if(Direction.TOP == thumbDir){
				path.lineTo(width*0.5+thumbSize, 0);
				path.lineTo(width*0.5, -thumbSize*2);
				path.lineTo(width*0.5-thumbSize, 0);
			}
			
			//左上点
			if(Direction.TOP_LEFT == thumbDir){
				path.lineTo(thumbSize, 0);
			}else{
				path.lineTo(0, 0);
			}
			
			return path;
		}
		
		static public function DrawBorder(g:Graphics, path:IPath, borderColor:uint, contentColor:uint, highlightBorderColor:uint):void
		{
			var g2d:Graphics2D = new Graphics2D(g);
			
			g2d.setPen(new SolidPen(3, borderColor));
			g2d.beginFill(new SolidBrush(contentColor, 0.6));
			g2d.drawPath(path);
			g2d.endFill();
			
			g2d.setPen(new SolidPen(1, highlightBorderColor));
			g2d.drawPath(path);
		}
		
		static public function DrawFlowTipBox(target:Sprite, pos:Point, size:Point, gap:Point, bound:Rect2D, defaultDir:String):void
		{
			var rect:Rect2D = new Rect2D(pos.x, pos.y, 0, 0);
			rect.inflate(size.x+gap.x, size.y+gap.y);
			
			var dir:String = bound.judgeDir(rect) || defaultDir;
			var g:Graphics = target.graphics;
			
			if(has(dir, Direction.LEFT)){
				target.x = pos.x + gap.x;
			}else if(has(dir, Direction.RIGHT)){
				target.x = pos.x - size.x - gap.x;
			}else{
				target.x = pos.x - size.x * 0.5;
			}
			
			if(has(dir, Direction.TOP)){
				target.y = pos.y + gap.y;
			}else if(has(dir, Direction.BOTTOM)){
				target.y = pos.y - size.y - gap.y;
			}else{
				target.y = pos.y - size.y * 0.5;
			}
			
			g.clear();
			DrawBorder(g, CreateInfoTipPath(size.x, size.y, dir), 0, 0xFFFFFF, 0xFFFF00);
		}
	}
}