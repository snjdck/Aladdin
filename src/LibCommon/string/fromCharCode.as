package string
{
	/**
	 * U+0000到U+10FFFF
	 * U+D800到U+DFFF
	 * 
	 * 0x263x 八卦
	 * @see http://zh.wikipedia.org/zh-tw/UTF-16
	 */
	public function fromCharCode(charCode:uint):String
	{
		if(charCode < 0x10000){
			return String.fromCharCode(charCode);
		}
		
		var v1:uint = 0xD800 | (0x3FF & ((charCode - 0x10000) >>> 10));
		var v2:uint = 0xDC00 | (0x3FF & charCode);
		
		return String.fromCharCode(v1, v2);
	}
}