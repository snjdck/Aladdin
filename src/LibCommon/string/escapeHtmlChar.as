package string
{
	public function escapeHtmlChar(str:String):String
	{
		return str.replace(/[<>&]/g, _replace);
	}
}

function _replace():String{
	return dict[arguments[0]];
}

const dict:Object = {
	"<":"&lt;",
	">":"&gt;",
	"&":"&amp;"
}