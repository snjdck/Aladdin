package ui.tabedpane
{
	public class TabNav extends AbstractTabedPane
	{
		public function TabNav()
		{
//			titleButtonFactory = DefaultAccordionTitleButton;
			tabGap = 6;
			maxVisibleTabCount = 1;
		}
		
		override protected function relayout():void
		{
			var offsetX:Number = 0;
			for each(var tab:Tab in tabList)
			{
				tab.title.x = offsetX;
				offsetX += tab.title.width + tabGap;
				
				if(tab.isContentShowing()){
					tab.component.y = tab.title.height;
				}
			}
		}
		
	}
}