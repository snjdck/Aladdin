package snjdck.entityengine
{
	import flash.utils.Dictionary;
	
	import dict.deleteKey;
	import dict.hasKey;
	
	import snjdck.signal.ISignal;
	import snjdck.signal.Signal;
	
	import stdlib.reflection.getType;

	public class Entity
	{
		public const onComponentAdd:Signal = new Signal(Entity);
		public const onComponentDel:Signal = new Signal(Entity);
		
		private const componentDict:Object = new Dictionary();
		
		public function Entity()
		{
			addComponent(this, Entity);
		}
		
		public function addComponent(component:Object, componentType:Class=null):void
		{
			if(null == componentType){
				componentType = getType(component);
			}
			if(hasComponent(componentType)){
				return;
			}
			componentDict[componentType] = component;
			onComponentAdd.notify(this);
		}
		
		public function delComponent(componentType:Class):*
		{
			if(false == hasComponent(componentType)){
				return;
			}
			var component:Object = deleteKey(componentDict, componentType);
			onComponentDel.notify(this);
			return component;
		}
		
		public function hasComponent(componentType:Class):Boolean
		{
			return hasKey(componentDict, componentType);
		}
		
		public function getComponent(componentType:Class):*
		{
			return componentDict[componentType];
		}
	}
}