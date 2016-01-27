package snjdck.g3d.core
{
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.pickup.Ray;
	import snjdck.g3d.render.DrawUnitCollector3D;
	
	use namespace ns_g3d;

	public class DisplayObjectContainer3D extends Object3D
	{
		private var _childList:Vector.<Object3D>;
		public var mouseChildren:Boolean;
		
		public function DisplayObjectContainer3D()
		{
			_childList = new <Object3D>[];
			mouseChildren = true;
		}
		
		override protected function onWorldMatrixDirty():void
		{
			super.onWorldMatrixDirty();
			for each(var child:Object3D in _childList){
				child.markWorldMatrixDirty();
			}
		}
		
		override public function onUpdate(timeElapsed:int):void
		{
			for each(var child:Object3D in _childList){
				child.onUpdate(timeElapsed);
			}
		}
		
		override ns_g3d function collectDrawUnit(collector:DrawUnitCollector3D):void
		{
			for each(var child:Object3D in _childList){
				if(child.isVisible()){
					child.collectDrawUnit(collector);
				}
			}
		}
		
		override public function hitTest(ray:Ray, result:Vector.<Object3D>):void
		{
			if(!(mouseEnabled || mouseChildren)){
				return;
			}
			ray.transform(transformInvert, tempRay);
			if(mouseEnabled && onHitTest(tempRay)){
				result.push(this);
			}
			if(false == mouseChildren){
				return;
			}
			for each(var child:Object3D in _childList){
				if(child.isVisible()){
					child.hitTest(tempRay, result);
				}
			}
		}
		
		public function addChild(child:Object3D):void
		{
			if(null == child || this == child || this == child.parent){
				return;
			}
			
			var needMarkWorldMatrixDirty:Boolean = true;
			if(child.parent != null){
				child.parent.removeChild(child);
				needMarkWorldMatrixDirty = false;
			}
			
			_childList.push(child);
			child._parent = this;
			if(needMarkWorldMatrixDirty){
				child.markWorldMatrixDirty();
			}
//			markOriginalBoundDirty();
		}
		
		public function removeChild(child:Object3D):void
		{
			if(null == child || this != child.parent){
				return;
			}
			removeChildAt(_childList.indexOf(child));
		}
		
		public function removeChildAt(index:int):void
		{
			if(index < 0 || index >= numChildren){
				return;
			}
			var child:Object3D = _childList[index];
			_childList.splice(index, 1);
			child._parent = null;
			child.markWorldMatrixDirty();
//			markOriginalBoundDirty();
		}
		
		public function getChildAt(index:int):Object3D
		{
			return _childList[index];
		}
		
		public function getChild(childName:String):Object3D
		{
			for each(var child:Object3D in _childList){
				if(child.name == childName){
					return child;
				}
			}
			return null;
		}
		
		public function findChild(childName:String):Object3D
		{
			var result:Object3D = getChild(childName);
			if(result != null){
				return result;
			}
			for each(var child:Object3D in _childList){
				var container:DisplayObjectContainer3D = child as DisplayObjectContainer3D;
				if(null == container){
					continue;
				}
				result = container.findChild(childName);
				if(result != null){
					return result;
				}
			}
			return null;
		}
		
		public function removeAllChildren():void
		{
			for each(var child:Object3D in _childList){
				child._parent = null;
				child.markWorldMatrixDirty();
			}
			_childList.length = 0;
		}
		
		public function removeChildByName(childName:String):void
		{
			removeChild(getChild(childName));
		}
		
		public function traverse(handler:Function, includeSelf:Boolean=true):void
		{
			if(includeSelf){
				handler(this);
			}
			for each(var child:Object3D in _childList){
				handler(child);
				var container:DisplayObjectContainer3D = child as DisplayObjectContainer3D;
				if(container != null){
					container.traverse(handler, false);
				}
			}
		}
		
		public function get numChildren():int
		{
			return _childList.length;
		}
	}
}