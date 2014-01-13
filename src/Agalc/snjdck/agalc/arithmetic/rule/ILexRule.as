package snjdck.agalc.arithmetic.rule
{
	import snjdck.agalc.arithmetic.node.Node;

	public interface ILexRule
	{
		function exec(input:String):Node;
	}
}