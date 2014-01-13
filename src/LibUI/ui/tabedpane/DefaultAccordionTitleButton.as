package ui.tabedpane
{
	import ui.button.Button;
	
	public class DefaultAccordionTitleButton extends Button
	{
		[Embed(source="/assets/formation_accordion_header_select.png")]
		static private const BUTTON_SELECTED:Class;
		
		[Embed(source="/assets/formation_accordion_header_normal.png")]
		static private const BUTTON_NORMAL:Class;
		
		[Embed(source="/assets/formation_accordion_header_pushed.png")]
		static private const BUTTON_PUSHED:Class;
		
		[Embed(source="/assets/formation_accordion_header_highlight.png")]
		static private const BUTTON_HIGHLIGHT:Class;
		
		public function DefaultAccordionTitleButton()
		{
			upSkin = new BUTTON_NORMAL();
			overSkin = new BUTTON_HIGHLIGHT();
			downSkin = new BUTTON_PUSHED();
			
			selectedUpSkin = new BUTTON_SELECTED();
			selectedOverSkin= new BUTTON_SELECTED();
			selectedDownSkin = new BUTTON_PUSHED();
			
			label.x = 10;
		}
	}
}