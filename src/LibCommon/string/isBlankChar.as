package string
{
	public function isBlankChar(char:String):Boolean
	{
		switch(char)
		{
			case " ":
			case "\t":
			case "\r":
			case "\n":
				return true;
		}
		return false;
	}
}