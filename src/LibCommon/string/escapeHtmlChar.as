package string
{
	public function escapeHtmlChar(input:String):String
	{
		return input.replace(regExp, _replace);
	}
}

var regExp:RegExp = /[<>&]/g;

function _replace(input:String, index:int, _:String):String
{
	switch(input){
		case "<": return "&lt;";
		case ">": return "&gt;";
		case "&": return "&amp;";
	}
	return null;
}