package flash.factory
{
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	 * 目前这个类封装了TextFormat中的13个属性,
	 * 还有5个没作封装,url, target, tabStops, bullet, kerning
	 * <br>
	 * leftMargin, rightMargin, indent, blockIndent, letterSpacing 去掉,剩余8个
	 * 
	 * 	<TEXTFORMAT LEFTMARGIN="0" RIGHTMARGIN="0" INDENT="0" BLOCKINDENT="0" LEADING="0">
	 *		<P ALIGN="LEFT">
	 *			<FONT FACE="宋体" SIZE="12" COLOR="#000000" LETTERSPACING="0" KERNING="0"></FONT>
	 *		</P>
	 *	</TEXTFORMAT>
	 */
	public function newTextField(parent:DisplayObjectContainer, autoSize:String=TextFieldAutoSize.NONE):TextField
	{
		var tf:TextField = new TextField();
		
		tf.mouseEnabled = false;
		tf.mouseWheelEnabled = false;
		tf.autoSize = autoSize;
		tf.multiline = true;
		tf.selectable = false;
		tf.wordWrap = true;
		
		if(null != parent){
			parent.addChild(tf);
		}
		
		return tf;
	}
}