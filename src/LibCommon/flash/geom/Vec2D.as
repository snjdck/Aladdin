package flash.geom
{
	import flash.display.Graphics;
	
	import math.nearEquals;

	final public class Vec2D
	{
		/**
		 * 返回两条直线的交点
		 * @param dirA 直线A的方向
		 * @param posA 直线A经过的点
		 * @param dirB 直线B的方向
		 * @param posB 直线B经过的点
		 * @return 两条直线的交点,如果没有交点,返回null
		 */
		static public function Intersection(dirA:Vec2D, posA:Vec2D, dirB:Vec2D, posB:Vec2D, result:Vec2D):Boolean
		{
			var divisor:Number = dirA.crossProd(dirB);
			
			if(nearEquals(0, divisor)){
				return false;
			}
			
			result.x = ((dirA.x * dirB.y * posB.x) - (dirA.y * dirB.x * posA.x) + (dirA.x * dirB.x * (posA.y - posB.y))) / divisor;
			result.y = ((dirA.x * dirB.y * posA.y) - (dirA.y * dirB.x * posB.y) + (dirA.y * dirB.y * (posB.x - posA.x))) / divisor;
			
			return true;
		}
		
		static public function Polar(len:Number, angle:Number):Vec2D
		{
			return new Vec2D(len * Math.cos(angle), len * Math.sin(angle));
		}
		
		static public function AngleBetween(va:Vec2D, vb:Vec2D):Number
		{
			return Math.acos(va.dotProd(vb)/(va.length*vb.length));
		}
		
		public var x:Number;
		public var y:Number;
		
		public function Vec2D(x:Number=0, y:Number=0)
		{
			this.x = x;
			this.y = y;
		}
		
		public function setTo(vx:Number, vy:Number):void
		{
			x = vx;
			y = vy;
		}
		
		public function get lengthSQ():Number
		{
			return (x * x) + (y * y);
		}
		
		public function get length():Number
		{
			return Math.sqrt(lengthSQ);
		}
		
		public function set length(val:Number):void
		{
			if(isZero()){
				x = val;
				return;
			}
			multiplyLocal(val / length);
		}
		
		public function get angle():Number
		{
			return Math.atan2(y, x);
		}
		
		public function set angle(val:Number):void
		{
			var d:Number = length;
			x = d * Math.cos(val);
			y = d * Math.sin(val);
		}
		
		public function truncate(max:Number):void
		{
			if(length > max){
				length = max;
			}
		}
		
		public function negate():Vec2D
		{
			return new Vec2D(-x, -y);
		}
		
		public function reverse():void
		{
			x = -x;
			y = -y;
		}
		
		public function dotProd(v:Vec2D):Number
		{
			return (x * v.x) + (y * v.y);
		}
		
		public function sign(v:Vec2D):int
		{
			return crossProd(v) < 0 ? -1 : 1;
		}
		
		/**
		 * perp.dotProd(v)
		 */
		public function crossProd(v:Vec2D):Number
		{
			return (x * v.y) - (y * v.x);
		}
		
		public function getPerp():Vec2D
		{
			return new Vec2D(-y, x);
		}
		
		public function distanceInside(other:Vec2D, distace:Number):Boolean
		{
			return distanceSQ(other) < distace * distace;
		}
		
		public function distanceOutside(other:Vec2D, distace:Number):Boolean
		{
			return distanceSQ(other) > distace * distace;
		}
		
		public function distanceEqual(other:Vec2D, distace:Number):Boolean
		{
			return distanceSQ(other) == distace * distace;
		}
		
		public function distanceSQ(v:Vec2D):Number
		{
			var dx:Number = x - v.x;
			var dy:Number = y - v.y;
			return dx * dx + dy * dy;
		}
		
		public function distance(v:Vec2D):Number
		{
			return Math.sqrt(distanceSQ(v));
		}
		
		public function add(v:Vec2D)			:Vec2D { return new Vec2D(x + v.x, y + v.y); }
		public function subtract(v:Vec2D)		:Vec2D { return new Vec2D(x - v.x, y - v.y); }
		public function multiply(value:Number)	:Vec2D { return new Vec2D(x * value, y * value); }
		public function divide(value:Number)	:Vec2D { return new Vec2D(x / value, y / value); }
		
		public function offset(dx:Number, dy:Number):void
		{
			x += dx;
			y += dy;
		}
		
		public function addLocal(v:Vec2D):void
		{
			x += v.x;
			y += v.y;
		}
		
		public function subtractLocal(v:Vec2D):void
		{
			x -= v.x;
			y -= v.y;
		}
		
		public function multiplyLocal(value:Number):void
		{
			x *= value;
			y *= value;
		}
		
		public function divideLocal(value:Number):void
		{
			x /= value;
			y /= value;
		}
		
		/**
		 * 坐标轴: x向右, y向下, 原点为坐标为this
		 * @param pta a点坐标
		 * @param ptb b点坐标
		 * @return 如果 ptb-this 在 pta-this 的顺时针方向,则返回值大于0, 逆时针方向则返回值小于0, 返回值0表示三点共线
		 */		
		public function clockwise(pta:Vec2D, ptb:Vec2D):Number
		{
			return pta.subtract(this).crossProd(ptb.subtract(this));
		}
		
		public function getVertexAngle(pta:Vec2D, ptb:Vec2D):Number
		{
			return AngleBetween(pta.subtract(this), ptb.subtract(this));
		}
		
		public function interpolate(target:Vec2D, f:Number):Vec2D
		{
			var pt:Vec2D = target.subtract(this);
			pt.multiplyLocal(f);
			pt.addLocal(this);
			return pt;
		}
		
		public function clone():Vec2D
		{
			return new Vec2D(x, y);
		}
		
		public function equals(v:Vec2D):Boolean
		{
			return nearEquals(x, v.x) && nearEquals(y, v.y);
		}
		
		public function normalize():void
		{
			if(isZero()){
				x = 1;
				return;
			}
			multiplyLocal(1 / length);
		}
		
		public function isZero():Boolean
		{
			return equals(new Vec2D(0, 0));
		}
		
		public function setZero():void
		{
			x = y = 0;
		}
		
		public function draw(g:Graphics, color:uint=0):void
		{
			g.lineStyle(0, color);
			g.moveTo(0, 0);
			g.lineTo(x, y);
		}
		
		public function toString():String
		{
			return "[Vector2D(x=" + x.toFixed(2) + ", y=" + y.toFixed(2) +  ")]";
		}
	}
}