package snjdck.entityengine
{
	import dict.deleteKey;
	import dict.hasKey;
	
	import flash.utils.Dictionary;
	
	import snjdck.signal.ISignal;
	import snjdck.signal.Signal;
	
	import stdlib.reflection.getType;

	public class Entity implements IComponent
	{
		public const onComponentAdd:Signal = new Signal(Entity);
		public const onComponentDel:Signal = new Signal(Entity);
		
		private const componentDict:Object = new Dictionary();
		private const behaviorDict:Object = new Dictionary();
		
		public function Entity()
		{
			addComponent(this, Entity);
		}
		
		public function addComponent(component:IComponent, componentType:Class=null):void
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
			var component:IComponent = deleteKey(componentDict, componentType);
			onComponentDel.notify(this);
			return component;
		}
		
		public function hasComponent(componentType:Class):Boolean
		{
			return hasKey(componentDict, componentType);
		}
		
		public function getComponent(componentType:Class):*
		{
			var component:IComponent = componentDict[componentType];
			return component;
		}
		
		public function addBehavior(behavior:IBehavior, behaviorType:Class=null):void
		{
			if(null == behaviorType){
				behaviorType = getType(behavior);
			}
			if(hasBehavior(behaviorType)){
				return;
			}
			behaviorDict[behaviorType] = behavior;
		}
		
		public function delBehavior(behaviorType:Class):*
		{
			if(false == hasBehavior(behaviorType)){
				return;
			}
			var behavior:IBehavior = deleteKey(behaviorDict, behaviorType);
			return behavior;
		}
		
		public function hasBehavior(behaviorType:Class):Boolean
		{
			return hasKey(behaviorDict, behaviorType);
		}
		
		public function getBehavior(behaviorType:Class):*
		{
			var behavior:IBehavior = behaviorDict[behaviorType];
			return behavior;
		}
	}
}