package flash.utils.sorter
{
	import string.replace;

	public class DependSorter
	{
		static public function resortList(input:Array):Array
		{
			var findingList:Array = [];
			var output:Array = [];
			for each(var item:DependSorterItem in input){
				insertItem(item, input, output, findingList);
			}
			return output;
		}
		
		static private function insertItem(item:DependSorterItem, input:Array, output:Array, findingList:Array):void
		{
			var isItemFinding:Boolean = findingList.indexOf(item) >= 0;
			findingList.push(item);
			if(isItemFinding){
				throw new Error(string.replace("service is recursively used:[${0}]", [findingList.join(" -> ")]));
			}
			for each(var key:Object in item.getDependList()){
				for each(var dependent:DependSorterItem in input){
					if(dependent.isMatch(key)){
						insertItem(dependent, input, output, findingList);
						break;
					}
				}
			}
			findingList.pop();
			if(output.indexOf(item) < 0){
				output.push(item);
			}
		}
	}
}