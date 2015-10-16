package string
{
	public function genFuncCall(funcName:String, argList:Array):String
	{
		return funcName + "(" + argList.join(", ") + ")";
	}
}