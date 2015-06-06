package string
{
	public function isHalfChar(char:String):Boolean
	{
		return char.charCodeAt() <= 0xFF;
	}
}