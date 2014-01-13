package ui
{
	import ui.button.Button;
	
	public class CheckBox extends Button
	{
		[Embed(source="/assets/checkbox_selected.png")]
		static private const CHECKBOX_SELECTED:Class;
		
		[Embed(source="/assets/checkbox_unselected.png")]
		static private const CHECKBOX_UNSELECTED:Class;
		
		public function CheckBox()
		{
			super();
			toggled = true;
		}
		
		override protected function initDefaultUI():void
		{
			upSkin = new CHECKBOX_UNSELECTED();
			overSkin = new CHECKBOX_UNSELECTED();
			downSkin = new CHECKBOX_UNSELECTED();
			
			selectedUpSkin = new CHECKBOX_SELECTED();
			selectedOverSkin = new CHECKBOX_SELECTED();
			selectedDownSkin = new CHECKBOX_SELECTED();
			
			label.x = 20;
		}
	}
}