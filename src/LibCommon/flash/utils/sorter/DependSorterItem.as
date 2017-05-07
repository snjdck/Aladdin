package flash.utils.sorter
{
	public interface DependSorterItem
	{
		function getDependList():Array;
		function isMatch(key:*):Boolean;
	}
}