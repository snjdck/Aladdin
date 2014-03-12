package flash.geom
{
	import flash.display.Graphics;
	
	import stdlib.constant.Direction;
	
	import math.nearEquals;

	final public class Rect2D
	{
		static public function Create(pa:Vec2D, pb:Vec2D):Rect2D
		{
			var rect:Rect2D = new Rect2D();
			
			rect.x = Math.min(pa.x, pb.x);
			rect.y = Math.min(pa.y, pb.y);
			rect.width = Math.abs(pa.x - pb.x);
			rect.height = Math.abs(pa.y - pb.y);
			
			return rect;
		}
		
		public var x:Number;
		public var y:Number;
		public var width:Number;
		public var height:Number;
		
		public function Rect2D(x:Number=0, y:Number=0, width:Number=0, height:Number=0)
		{
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
		}
		
		public function get halfWidth():Number
		{
			return 0.5 * width;
		}
		
		public function get halfHeight():Number
		{
			return 0.5 * height;
		}
		
		public function get left():Number
		{
			return x;
		}
		
		public function set left(value:Number):void
		{
			width += x - value;
			x = value;
		}
		
		public function get right():Number
		{
			return x + width;
		}
		
		public function set right(value:Number):void
		{
			width = value - x;
		}
		
		public function get top():Number
		{
			return y;
		}
		
		public function set top(value:Number):void
		{
			height += y - value;
			y = value;
		}
		
		public function get bottom():Number
		{
			return y + height;
		}
		
		public function set bottom(value:Number):void
		{
			height = value - y;
		}
		
		public function get topLeft():Vec2D
		{
			return new Vec2D(left, top);
		}
		
		public function set topLeft(pt:Vec2D):void
		{
			left = pt.x;
			top = pt.y;
		}
		
		public function get topRight():Vec2D
		{
			return new Vec2D(right, top);
		}
		
		public function set topRight(pt:Vec2D):void
		{
			right = pt.x;
			top = pt.y;
		}
		
		public function get bottomLeft():Vec2D
		{
			return new Vec2D(left, bottom);
		}
		
		public function set bottomLeft(pt:Vec2D):void
		{
			left = pt.x;
			bottom = pt.y;
		}
		
		public function get bottomRight():Vec2D
		{
			return new Vec2D(right, bottom);
		}
		
		public function set bottomRight(pt:Vec2D):void
		{
			right = pt.x;
			bottom = pt.y;
		}
		
		public function get size():Vec2D
		{
			return new Vec2D(width, height);
		}
		
		public function set size(val:Vec2D):void
		{
			width = val.x;
			height = val.y;
		}
		
		public function get center():Vec2D
		{
			return new Vec2D(left+halfWidth, top+halfHeight);
		}
		
		public function set center(pt:Vec2D):void
		{
			offsetVec(pt.subtract(center));
		}
		
		public function get leftCenter():Vec2D
		{
			return new Vec2D(left, top+halfHeight);
		}
		
		public function set leftCenter(pt:Vec2D):void
		{
			offsetVec(pt.subtract(leftCenter));
		}
		
		public function get rightCenter():Vec2D
		{
			return new Vec2D(right, top+halfHeight);
		}
		
		public function set rightCenter(pt:Vec2D):void
		{
			offsetVec(pt.subtract(rightCenter));
		}
		
		public function get topCenter():Vec2D
		{
			return new Vec2D(left+halfWidth, top);
		}
		
		public function set topCenter(pt:Vec2D):void
		{
			offsetVec(pt.subtract(topCenter));
		}
		
		public function get bottomCenter():Vec2D
		{
			return new Vec2D(left+halfWidth, bottom);
		}
		
		public function set bottomCenter(pt:Vec2D):void
		{
			offsetVec(pt.subtract(bottomCenter));
		}
		
		public function clone():Rect2D
		{
			return new Rect2D(x, y, width, height);
		}
		
		public function equals(rect:Rect2D):Boolean
		{
			return nearEquals(rect.x, this.x)
				&& nearEquals(rect.y, this.y)
				&& nearEquals(rect.width, this.width)
				&& nearEquals(rect.height, this.height);
		}
		
		public function isEmpty():Boolean
		{
			return width <= 0 || height <= 0;
		}
		
		public function setEmpty():void
		{
			x = y = width = height = 0;
		}
		
		public function inflate(dx:Number, dy:Number):void
		{
			x -= dx;
			y -= dy;
			width += dx * 2;
			height += dy * 2;
		}
		
		public function offset(dx:Number, dy:Number):void
		{
			x += dx;
			y += dy;
		}
		
		public function offsetVec(vec:Vec2D):void
		{
			offset(vec.x, vec.y);
		}
		
		public function contains(px:Number, py:Number):Boolean
		{
			return px >= this.x
				&& py >= this.y
				&& px < this.right
				&& py < this.bottom;
		}
		
		public function containsPoint(pt:Vec2D):Boolean
		{
			return contains(pt.x, pt.y);
		}
		
		public function containsRect(rect:Rect2D):Boolean
		{
			return containsPoint(rect.topLeft) && containsPoint(rect.bottomRight);
		}
		
		public function intersection(toIntersect:Rect2D):Rect2D
		{
			var rect:Rect2D = new Rect2D();
			
			if(this.isEmpty() || toIntersect.isEmpty()){
				return rect;
			}
			
			rect.x = Math.max(toIntersect.x, this.x);
			rect.y = Math.max(toIntersect.y, this.y);
			rect.right = Math.min(toIntersect.right, this.right);
			rect.bottom = Math.min(toIntersect.bottom, this.bottom);
			
			if(rect.isEmpty()){
				rect.setEmpty();
			}
			
			return rect;
		}
		
		public function intersects(toIntersect:Rect2D):Boolean
		{
			return !intersection(toIntersect).isEmpty();
		}
		
		public function union(toUnion:Rect2D):Rect2D
		{
			if(this.isEmpty()){
				return toUnion.clone();
			}
			
			if(toUnion.isEmpty()){
				return this.clone();
			}
			
			var rect:Rect2D = new Rect2D();
			
			rect.x = Math.min(toUnion.x, this.x);
			rect.y = Math.min(toUnion.y, this.y);
			rect.right = Math.max(toUnion.right, this.right);
			rect.bottom = Math.max(toUnion.bottom, this.bottom);
			
			return rect;
		}
		
		public function judgeDir(target:Rect2D):String
		{
			return judgeDirV(target) + judgeDirH(target);
		}
		
		public function judgeDirH(target:Rect2D):String
		{
			var inLeft:Boolean = target.left < this.left;
			var inRight:Boolean = target.right > this.right;
			
			return (inLeft != inRight) ? (inLeft ? Direction.LEFT : Direction.RIGHT) : Direction.CENTER;
		}
		
		public function judgeDirV(target:Rect2D):String
		{
			var inTop:Boolean = target.top < this.top;
			var inBottom:Boolean = target.bottom > this.bottom;
			
			return (inTop != inBottom) ? (inTop ? Direction.TOP : Direction.BOTTOM) : Direction.CENTER;
		}
		
		public function drawPath(g:Graphics):void
		{
			g.drawRect(x, y, width, height);
		}
		
		public function toString():String
		{
			return "[Rect2D(x=" + x + ", y=" + y + ", w=" + width + ", h=" + height +  ")]";
		}
	}
}