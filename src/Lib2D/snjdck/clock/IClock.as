package snjdck.clock
{
	public interface IClock
	{
		function add(ticker:ITicker):void;
		function remove(ticker:ITicker):void;
	}
}