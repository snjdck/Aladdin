package snjdck.editor
{
	public class ClipBoard
	{
		private var target:Object;
		private var cutFlag:Boolean;
		
		public function ClipBoard()
		{
		}
		
		public function copy(target:Object):void
		{
			this.target = target;
			cutFlag = false;
		}
		public function cut(target:Object):void
		{
			this.target = target;
			cutFlag = true;
		}
		
		public function paste():void
		{
			
		}
	}
}