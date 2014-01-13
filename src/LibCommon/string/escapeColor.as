package string
{
	/**
	 * [#FFFFFF abc] -> <font color='#FFFFFF'>abc</font>
	 */
	public function escapeColor(str:String):String
	{
		var pattern:RegExp = /\[(#[0-9a-fA-F]{1,6})\s(.+)\]/s;
		while(str.search(pattern) != -1){
			str = str.replace(pattern, "<font color='$1'>$2</font>");
		}
		return str;
	}
}