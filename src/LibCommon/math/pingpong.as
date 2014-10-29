package math
{
	public function pingpong(value:Number, length:Number):Number
	{
		var div:Number = value / length;
		var count:int = Math.floor(div);
		var result:Number = (div - count) * length;
		return (count & 1) > 0 ? (length - result) : result;
	}
}