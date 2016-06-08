package flash.support
{
	final public class Operator
	{
		static public function Add(a:*, b:*):*
		{
			return a + b;
		}
		
		static public function Subtract(a:*, b:*):*
		{
			return a - b;
		}
		
		static public function Multiply(a:*, b:*):*
		{
			return a * b;
		}
		
		static public function Divide(a:*, b:*):*
		{
			return a / b;
		}
		
		static public function Modulus(a:*, b:*):*
		{
			return a % b;
		}
		
		static public function Not(value:*):Boolean
		{
			return !value;
		}
		
		static public function And(a:*, b:*):Boolean
		{
			return a && b;
		}
		
		static public function Or(a:*, b:*):Boolean
		{
			return a || b;
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