package flash.text
{
	import string.replace;

	public class HtmlText
	{
		private var value:String;
		
		public function HtmlText(value:Object)
		{
			this.value = value.toString();
		}
		
		public function clone():HtmlText
		{
			return new HtmlText(value);
		}
		
		public function toString():String
		{
			return value;
		}
		
		public function prepend(text:Object):HtmlText
		{
			value = text + value;
			return this;
		}
		
		public function append(text:Object):HtmlText
		{
			value += text;
			return this;
		}
		
		public function join(left:Object, right:Object):HtmlText
		{
			value = left + value + right;
			return this;
		}
		
		public function color(fontColor:uint):HtmlText
		{
			return join(replace("<font color='#${0}'>", [fontColor.toString(16)]), "</font>");
		}
		
		public function color2(fontColor:String):HtmlText
		{
			return color(parseInt(fontColor, 16));
		}
		
		public function size(fontSize:int):HtmlText
		{
			return join(replace("<font size='${0}'>", [fontSize]), "</font>");
		}
		
		public function link(href:String):HtmlText
		{
			return join(replace("<a href='${0}'>", [href]), "</a>");
		}
		
		public function eventLink(event:String):HtmlText
		{
			return link("event:" + event);
		}
		
		public function newline():HtmlText
		{
			return append("<br/>");
		}
		
		public function bold():HtmlText
		{
			return join("<b>", "</b>");
		}
		
		public function italic():HtmlText
		{
			return join("<i>", "</i>");
		}
		
		public function underline():HtmlText
		{
			return join("<u>", "</u>");
		}
		
		public function span():HtmlText
		{
			return join("<span class='default'>", "</span>");
		}
		
		public function p(align:String="left"):HtmlText
		{
			return join(replace("<p align='${0}'>", [align]), "</p>");
		}
	}
}