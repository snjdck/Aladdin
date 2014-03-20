package flash.support
{
	final public class Operator
	{
		static public function Add(a:Number, b:Number):Number
		{
			return a + b;
		}
		
		static public function Subtract(a:Number, b:Number):Number
		{
			return a - b;
		}
		
		static public function Equal(a:Object, b:Object):Boolean
		{
			return a == b;
		}
		
		static public function NotEqual(a:Object, b:Object):Boolean
		{
			return a != b;
		}
		
		static public function GreaterEqual(a:Object, b:Object):Boolean
		{
			return a >= b;
		}
		
		static public function GreaterThan(a:Object, b:Object):Boolean
		{
			return a > b;
		}
		
		static public function LessEqual(a:Object, b:Object):Boolean
		{
			return a <= b;
		}
		
		static public function LessThan(a:Object, b:Object):Boolean
		{
			return a < b;
		}
	}
}