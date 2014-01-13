package snjdck.agalc.helper
{
	public function char2val(char:String, offset:int=0):uint
	{
		switch(char.charAt(offset))
		{
			case "x":
			case "r":
				return 0;
			case "y":
			case "g":
				return 1;
			case "z":
			case "b":
				return 2;
			case "w":
			case "a":
				return 3;
		}
		throw new Error("error input!");
	}
}