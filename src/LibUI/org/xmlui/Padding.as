package org.xmlui
{
	public class Padding
	{
		public var top:Number;
		public var right:Number;
		public var bottom:Number;
		public var left:Number;
		
		public function Padding()
		{
			top = 0;
			right = 0;
			bottom = 0;
			left = 0;
		}
		
		public function get width():Number
		{
			return left + right;
		}
		
		public function get height():Number
		{
			return top + bottom;
		}
		
		public function add(another:Padding):Padding
		{
			return null;
		}
	}
}