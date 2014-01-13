package ui.tabedpane
{
	import flash.events.MouseEvent;
	
	import ui.button.Button;
	import ui.core.Component;
	
	public class Accordion extends AbstractTabedPane
	{
		public function Accordion()
		{
			titleButtonFactory = DefaultAccordionTitleButton;
			tabGap = 6;
			allowEmptyFocusTab = true;
		}
	}
}