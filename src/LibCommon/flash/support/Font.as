package flash.support
{
	final public class Font
	{
		public var name:String;
		public var size:uint;
		public var color:uint;
		
		public var underline:Boolean;
		public var italic:Boolean;
		public var bold:Boolean;
		
		public function Font(name:String="Verdana", size:uint=12, color:uint=0x000000, bold:Boolean=false, italic:Boolean=false, underline:Boolean=false)
		{
			this.name = name;
			this.size = size;
			this.color = color;
			this.bold = bold;
			this.italic = italic;
			this.underline = underline;
		}
		
		public function getCssColor():String
		{
			return "#" + color.toString(16);
		}
		
		public function getHtmlText(text:String):String
		{
			var html:String = text;
			
			if(underline)	html = "<U>" + html + "</U>";
			if(italic)		html = "<I>" + html + "</I>";
			if(bold)		html = "<B>" + html + "</B>";
			
			return html;
		}
	}
}