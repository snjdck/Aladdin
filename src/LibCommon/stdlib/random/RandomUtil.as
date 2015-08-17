package stdlib.random
{
	public class RandomUtil
	{
		static public function getBool():Boolean
		{
			return Math.random() < 0.5;
		}
		
		static public function getSign():int
		{
			return getBool() ? 1 : -1;
		}
		
		static public function getInt(a:int, b:int):int
		{
			return a + (b - a) * Math.random();
		}
		
		static public function getString(source:Array, count:int=1):String
		{
			var charList:Array = [];
			while(charList.length < count){
				var charIndex:int = source.length * Math.random();
				charList.push(source[charIndex]);
			}
			return charList.join("");
		}
		
		static public function getString2(sourceCode:Array, count:int=1):String
		{
			var charCodeList:Array = [];
			while(charCodeList.length < count){
				var charIndex:int = sourceCode.length * Math.random();
				charCodeList.push(sourceCode[charIndex]);
			}
			return String.fromCharCode.apply(null, charCodeList);
		}
		
		static public function getArrayItem(list:Array, remove:Boolean=false):*
		{
			var index:int = list.length * Math.random();
			if(remove){
				return list.splice(index, 1)[0];
			}
			return list[index];
		}
		
		static public function createGen(seed:uint):Function
		{
			return function():Number
			{
				seed ^= seed << 21;
				seed ^= seed >>> 35;
				seed ^= seed << 4;
				return seed / uint.MAX_VALUE;
			};
		}
	}
}