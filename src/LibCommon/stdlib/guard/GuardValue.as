package stdlib.guard
{
	final public class GuardValue
	{
		public var isDirty:Boolean;
		private var valueToSet:*;
		
		public function GuardValue(){}
		
		public function valueOf():*
		{
			return valueToSet;
		}
		
		public function clear():void
		{
			isDirty = false;
			valueToSet = null;
		}
		
		public function getValue(oldValue:Object):*
		{
			return isDirty ? valueToSet : oldValue;
		}
		
		public function setValue(newValue:Object, oldValue:Object):void
		{
			if(isDirty){
				if(newValue == oldValue){
					isDirty = false;
					valueToSet = null;
				}else if(newValue != valueToSet){
					valueToSet = newValue;
				}
			}else if(newValue != oldValue){
				isDirty = true;
				valueToSet = newValue;
			}
		}
	}
}