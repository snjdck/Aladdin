package array
{
	public function swapValueAt(list:Array, indexA:int, indexB:int):void
	{
		if(indexA == indexB){
			return;
		}
		var temp:Object = list[indexA];
		list[indexA] = list[indexB];
		list[indexB] = temp;
	}
}