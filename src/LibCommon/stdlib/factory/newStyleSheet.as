package stdlib.factory
{
	import flash.text.StyleSheet;
	
	import snjdck.text.Font;

	public function newStyleSheet(font:Font, align:String, leading:int):StyleSheet
	{
		var styleSheet:StyleSheet = new StyleSheet();
		styleSheet.setStyle("a:link",	{"textDecoration":"underline"});
		styleSheet.setStyle("a:visited",{"textDecoration":"underline"});
		styleSheet.setStyle("a:hover",	{"textDecoration":"underline"});
		styleSheet.setStyle("a:active ",{"textDecoration":"underline"});
		styleSheet.setStyle(".default", {
			"fontFamily":		font.name,
			"color":			font.getCssColor(),
			"fontSize":			font.size,
			"fontWeight":		(font.bold?"bold":"normal"),
			"fontStyle":		(font.italic?"italic":"normal"),
			"textDecoration":	(font.underline?"underline":"none"),
			"textAlign":		align,
			"leading":			leading
		});
		return styleSheet;
	}
}