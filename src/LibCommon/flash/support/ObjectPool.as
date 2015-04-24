package flash.support
{
	import array.del;
	import array.has;
	
	import lambda.apply;
	
	import flash.reflection.getTypeName;

	final public class ObjectPool
	{
		private const refList:Array = [];			//所有创建的对象引用列表,防止对象被回收
		private const unusedItems:Array = [];		//可用的对象列表
		private const usedItems:Array = [];
		
		private var objType:Class;
		private var objCtorArgs:Array;
		
		public function ObjectPool(objType:Class, objCtorArgs:Array=null)
		{
			this.objType = objType;
			this.objCtorArgs = objCtorArgs;
		}
		
		public function getObjectOut():*
		{
			var obj:Object = unusedItems.length > 0 ? unusedItems.pop() : createObject();
			usedItems.push(obj);
			return obj;
		}
		
		public function setObjectIn(obj:Object):void
		{
			if(has(usedItems, obj)){
				del(usedItems, obj);
				unusedItems.push(obj);
			}else{
				throw new Error("对象池中存入不是由对象池生成的对象！");
			}
		}
		
		public function recyleUsedItems(handler:Function=null):void
		{
			while(usedItems.length > 0){
				var item:Object = usedItems.pop();
				if(handler != null){
					handler(item);
				}
				unusedItems.push(item);
			}
		}
		
		private function createObject():Object
		{
			var obj:Object = apply(objType, objCtorArgs);
			refList.push(obj);
			return obj;
		}
		
		public function toString():String
		{
			return "[ObjectPool.<" + getTypeName(objType, true) + ">(总数: " + refList.length + ", 可用: " + unusedItems.length + ")]";
		}
	}
}