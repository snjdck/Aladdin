package stdlib.random
{
	public function random_word(nChar:int=1):String
	{
		var charList:Array = [];
		while(charList.length < nChar){
			var charIndex:int = words.length * Math.random();
			charList.push(words[charIndex]);
		}
		return charList.join("");
	}
}

const words:Array = [
	"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
	"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"
];