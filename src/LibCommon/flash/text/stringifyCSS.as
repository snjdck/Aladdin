package flash.text
{
	public function stringifyCSS(target:StyleSheet):String
	{
		var result:String = "";
		
		for each(var styleName:String in target.styleNames)
		{
			result += styleName + " {\n";
			
			var obj:Object = target.getStyle(styleName);
			
			for(var key:String in obj)
			{
				result += "\t" + key + " : " + obj[key] + ";\n";
			}
			
			result += "}\n";
		}
		
		return result;
	}
}