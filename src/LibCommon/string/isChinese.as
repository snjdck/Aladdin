package string
{
	public function isChinese(str:String):Boolean
	{
		for(var i:int=0, n:int=str.length; i<n; ++i){
			var charCode:int = str.charCodeAt(i);
			if(charCode < 0x4E00 || 0x9FBB < charCode){
				return false;
			}
		}
		return true;
	}
}