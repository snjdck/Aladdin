package snjdck.g3d.core
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.support.DataEvent;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.pickup.Ray;
	import snjdck.g3d.pickup.RayTestInfo;
	import snjdck.g3d.pickup.RayCastStack;
	import snjdck.g3d.render.DrawUnitCollector3D;
	import snjdck.gpu.BlendMode;
	
	use namespace ns_g3d;
	
	[Event(name="enterFrame", type="flash.events.Event")]
	[Event(name="click", type="flash.events.MouseEvent")]
	
	public class Object3D extends EventDispatcher
	{
		private var _parent:Object3D;
		private var _nextSibling:Object3D;
		private var _firstChild:Object3D;
		
		private const _position:Vector3D = new Vector3D();
		private const _rotation:Vector3D = new Vector3D();
		private const _scale:Vector3D = new Vector3D(1, 1, 1);
		private const matrixComponents:Vector.<Vector3D> = new <Vector3D>[_position,_rotation,_scale];
		
		private var isLocalMatrixDirty:Boolean;
		ns_g3d const localMatrix:Matrix3D = new Matrix3D();
		
		public var width:Number, height:Number, length:Number;
		public var layer:uint;
		public var visible:Boolean;
		public var name:String;
		
		public var mouseEnabled:Boolean;
		public var mouseChildren:Boolean;
		
		private var _blendMode:BlendMode;
		
		public function Object3D()
		{
			visible = true;
			mouseEnabled = true;
			mouseChildren = true;
		}

		public function get nextSibling():Object3D
		{
			return _nextSibling;
		}
		
		public function get firstChild():Object3D
		{
			return _firstChild;
		}
		
		private function get lastChild():Object3D
		{
			if(null == _firstChild){
				return null;
			}
			var child:Object3D = _firstChild;
			while(child.nextSibling != null){
				child = child.nextSibling;
			}
			return child;
		}
		
		public function get transform():Matrix3D
		{
			if(isLocalMatrixDirty){
				localMatrix.recompose(matrixComponents);
				isLocalMatrixDirty = false;
			}
			return localMatrix;
		}
		
		public function onUpdate(timeElapsed:int):void
		{
			for(var child:Object3D=firstChild; child; child=child.nextSibling){
				child.onUpdate(timeElapsed);
			}
		}
		
		ns_g3d function collectDrawUnit(collector:DrawUnitCollector3D):void
		{
			if(null == firstChild){
				return;
			}
			collector.pushMatrix(transform);
			for(var child:Object3D=firstChild; child; child=child.nextSibling){
				if(child.visible){
					child.collectDrawUnit(collector);
				}
			}
			collector.popMatrix();
		}
		
		final public function hitTest(rayCastStack:RayCastStack, result:Vector.<RayTestInfo>):void
		{
			if(!(mouseEnabled || mouseChildren)){
				return;
			}
			rayCastStack.pushRay(transform);
			if(mouseEnabled){
				hitTestImpl(rayCastStack.ray, result);
			}
			if(false == mouseChildren){
				rayCastStack.popRay();
				return;
			}
			for(var child:Object3D=firstChild; child; child=child.nextSibling){
				if(child.visible){
					child.hitTest(rayCastStack, result);
				}
			}
			rayCastStack.popRay();
		}
		
		virtual protected function hitTestImpl(localRay:Ray, result:Vector.<RayTestInfo>):void{}
		
		public function addChild(child:Object3D):void
		{
			if(null == child || this == child || this == child.parent){
				return;
			}
			
			if(child.parent){
				child.parent.removeChild(child);
			}
			
			child._parent = this;
			
			if(null == _firstChild){
				_firstChild = child;
			}else{
				lastChild._nextSibling = child;
			}
		}
		
		public function removeChild(child:Object3D):void
		{
			if(null == child || this != child.parent){
				return;
			}
			
			if(child == firstChild){
				_firstChild = child.nextSibling;
			}else{
				var prevChild:Object3D = firstChild;
				while(prevChild.nextSibling != child){
					prevChild = prevChild.nextSibling;
				}
				prevChild._nextSibling = child.nextSibling;
			}
			
			child._parent = null;
			child._nextSibling = null;
		}
		
		public function getChild(childName:String):Object3D
		{
			for(var child:Object3D=firstChild; child; child=child.nextSibling){
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
			for(var child:Object3D=firstChild; child; child=child.nextSibling){
				result = child.findChild(childName);
				if(result != null){
					return result;
				}
			}
			return null;
		}
		/*
		public function get scene():Scene3D
		{
			return parent ? parent.scene : null;
		}
		*/
		public function get parent():Object3D
		{
			return _parent;
		}
		
		public function set scale(val:Number):void
		{
			_scale.x = _scale.y = _scale.z = val;
			isLocalMatrixDirty = true;
		}

		public function get blendMode():BlendMode
		{
			return _blendMode;
		}

		public function set blendMode(value:BlendMode):void
		{
			_blendMode = value;
		}

		public function get x():Number
		{
			return _position.x;
		}

		public function set x(value:Number):void
		{
			_position.x = value;
			isLocalMatrixDirty = true;
		}

		public function get y():Number
		{
			return _position.y;
		}

		public function set y(value:Number):void
		{
			_position.y = value;
			isLocalMatrixDirty = true;
		}

		public function get z():Number
		{
			return _position.z;
		}

		public function set z(value:Number):void
		{
			_position.z = value;
			isLocalMatrixDirty = true;
		}

		public function get scaleX():Number
		{
			return _scale.x;
		}

		public function set scaleX(value:Number):void
		{
			_scale.x = value;
			isLocalMatrixDirty = true;
		}

		public function get scaleY():Number
		{
			return _scale.y;
		}

		public function set scaleY(value:Number):void
		{
			_scale.y = value;
			isLocalMatrixDirty = true;
		}

		public function get scaleZ():Number
		{
			return _scale.z;
		}

		public function set scaleZ(value:Number):void
		{
			_scale.z = value;
			isLocalMatrixDirty = true;
		}

		public function get rotationX():Number
		{
			return _rotation.x;
		}

		public function set rotationX(value:Number):void
		{
			_rotation.x = value;
			isLocalMatrixDirty = true;
		}

		public function get rotationY():Number
		{
			return _rotation.y;
		}

		public function set rotationY(value:Number):void
		{
			_rotation.y = value;
			isLocalMatrixDirty = true;
		}

		public function get rotationZ():Number
		{
			return _rotation.z;
		}

		public function set rotationZ(value:Number):void
		{
			_rotation.z = value;
			isLocalMatrixDirty = true;
		}
		
		public function get opaque():Boolean
		{
			return BlendMode.NORMAL == _blendMode;
		}
		
		public function set opaque(value:Boolean):void
		{
			_blendMode = value ? BlendMode.NORMAL : BlendMode.ALPHAL;
		}
		
		public function removeFromParent():void
		{
			if(null != parent){
				parent.removeChild(this);
			}
		}
		
		public function translateLocal(axis:Vector3D, distance:Number):void
		{
			var size:Number = distance / axis.length;
			
			transform.prependTranslation(axis.x * size, axis.y * size, axis.z * size);
			transform.copyColumnTo(3, tempPoint);
			_position.x = tempPoint.x;
			_position.y = tempPoint.y;
			_position.z = tempPoint.z;
		}
		
		private const _worldMatrix:Matrix3D = new Matrix3D();
		
		public function get worldMatrix():Matrix3D
		{
//			_worldMatrix.copyFrom(transform);
			_worldMatrix.identity();
			var target:Object3D = this.parent;
			while(target != null){
				_worldMatrix.append(target.transform);
				target = target.parent;
			}
			return _worldMatrix;
		}
		/*
		public function localToGlobal(pt:Vector3D):Vector3D
		{
			return worldMatrix.transformVector(pt);
		}
		
		public function globalToLocal(pt:Vector3D):Vector3D
		{
			tempMatrix.copyFrom(worldMatrix);
			tempMatrix.invert();
			return tempMatrix.transformVector(pt);
		}
		//*/
		ns_g3d function hasMouseEvent(evtType:String):Boolean
		{
			if(hasEventListener(evtType)){
				return true;
			}
			for(var child:Object3D=firstChild; child; child=child.nextSibling){
				if(child.hasMouseEvent(evtType)){
					return true;
				}
			}
			return false;
		}
		
		public function notifyMouseEvent(evtType:String, rayTestInfo:RayTestInfo):void
		{
			notifyEvent(new DataEvent(evtType, rayTestInfo, true));
		}
		//*
		private function notifyEvent(evt:Event):Boolean
		{
			var result:Boolean;
			
			if(hasEventListener(evt.type)){
				result = dispatchEvent(evt);
			}
			
			if(evt.bubbles && parent){
				parent.notifyEvent(evt);
			}
			
			return result;
		}
		//*/
		
		//--------------------------util methods---------------------
		
		public function removeAllChildren():void
		{
			while(firstChild != null){
				removeChild(firstChild);
			}
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
			for(var child:Object3D=firstChild; child != null; child=child.nextSibling){
				child.traverse(handler, true);
			}
		}
		
		public function get numChildren():int
		{
			var count:int = 0;
			for(var child:Object3D=firstChild; child != null; child=child.nextSibling){
				count++;
			}
			return count;
		}
		
		public function createChild(childName:String=null):Object3D
		{
			var child:Object3D = new Object3D();
			child.name = childName;
			addChild(child);
			return child;
		}
		
		public function getPosition():Vector3D
		{
			return new Vector3D(x, y, z);
		}
		
		public function moveTo(px:Number, py:Number, pz:Number):void
		{
			this.x = px;
			this.y = py;
			this.z = pz;
		}
		
		public function setPosition(value:Vector3D):void
		{
			moveTo(value.x, value.y, value.z);
		}
		
		public function moveForward(distance:Number):void
		{
			translateLocal(Vector3D.Z_AXIS, distance);
		}
		
		public function moveBackward(distance:Number):void
		{
			moveForward(-distance);
		}
		
		public function moveUp(distance:Number):void
		{
			translateLocal(Vector3D.Y_AXIS, distance);
		}
		
		public function moveDown(distance:Number):void
		{
			moveUp(-distance);
		}
		
		public function moveLeft(distance:Number):void
		{
			moveRight(-distance);
		}
		
		public function moveRight(distance:Number):void
		{
			translateLocal(Vector3D.X_AXIS, distance);
		}
	}
}

import flash.geom.Matrix3D;
import flash.geom.Vector3D;

const tempPoint:Vector3D = new Vector3D();
const tempMatrix:Matrix3D = new Matrix3D();