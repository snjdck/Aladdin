package stdlib.random
{
	public function random_string(source:Array, count:int=1):String
	{
		var charList:Array = [];
		while(charList.length < count){
			var charIndex:int = source.length * Math.random();
			charList.push(source[charIndex]);
		}
		return charList.join("");
	}
}