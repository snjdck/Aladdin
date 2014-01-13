package array
{
	public function shuffle(list:Array):void
	{
		for(var i:int=list.length; i>1; i--){
			swapValueAt(list, i-1, i*Math.random());
		}
	}
}