package stdlib.random
{
	import operator.add;
	
	import array.getField;
	import array.reduce;

	/**
	 * list = [{"data":"a", "probability":0.1}, {"data":"b", "probability":0.9}]
	 * <br>
	 * random_getValueByProbability(list, "probability", 0.3) => list[1]
	 */	
	public function random_getValueByProbability(list:Array, keyName:String, randomValue:Number=NaN):*
	{
		if(isNaN(randomValue)){
			randomValue = Math.random();
		}
		
		const valList:Array = getField(list, keyName);
		randomValue *= reduce(valList, operator.add, 0);//求和
		
		for(var i:int=0, n:int=valList.length; i<n; i++)
		{
			var val:Number = valList[i];
			if(randomValue < val){
				return list[i];
			}
			randomValue -= val;
		}
		
		return null;
	}
}