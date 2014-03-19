package stdlib.constant
{
	final public class Char
	{
		static public const Words:Array = [
			"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
			"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"
		];
		static public const Digit:Array = [
			"0","1","2","3","4","5","6","7","8","9"
		];
		static public const Var1:Array = ["$","_"].concat(Words);
		static public const Var2:Array = ["$","_"].concat(Words).concat(Digit);
	}
}