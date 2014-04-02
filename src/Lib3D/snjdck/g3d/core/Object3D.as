package snjdck.g3d.core
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.support.DataEvent;
	
	import matrix44.recompose;
	
	import snjdck.g2d.core.IDisplayObject;
	import snjdck.g3d.asset.IGpuContext;
	import snjdck.g3d.geom.Ray;
	import snjdck.g3d.geom.RayTestInfo;
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.render.Render3D;
	
	use namespace ns_g3d;
	
	[Event(name="enterFrame", type="flash.events.Event")]
	[Event(name="click", type="flash.events.MouseEvent")]
	
	public class Object3D extends EventDispatcher implements IDisplayObject
	{
		private var _parent:Object3D;
		private var _nextSibling:Object3D;
		private var _firstChild:Object3D;
		
		private var pivotX:Number=0, pivotY:Number=0, pivotZ:Number=0;
		private var _x:Number=0, _scaleX:Number=1, _rotationX:Number=0;
		private var _y:Number=0, _scaleY:Number=1, _rotationY:Number=0;
		private var _z:Number=0, _scaleZ:Number=1, _rotationZ:Number=0;
		
		private var isLocalMatrixDirty:Boolean;
		ns_g3d const localMatrix:Matrix3D = new Matrix3D();
		ns_g3d const worldMatrix:Matrix3D = new Matrix3D();
		
		public var width:Number, height:Number, length:Number;
		private var _alpha:Number = 0;
		private var _visible:Boolean;
		public var name:String;
		
		public var mouseEnabled:Boolean;
		public var mouseChildren:Boolean;
		
		public var typeName:String;
		
		private var _blendMode:BlendMode;
		
		public function Object3D(name:String=null, typeName:String=null)
		{
			this.name = name;
			this.typeName = typeName;
			
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
		
		private function calcTransform():void
		{
			recompose(localMatrix, _x, _y, _z, _rotationX, _rotationY, _rotationZ, _scaleX, _scaleY, _scaleZ);
			if(0 == pivotX && 0 == pivotY && 0 == pivotZ) return;
			localMatrix.prependTranslation(-pivotX, -pivotY, -pivotZ);
		}
		
		public function get transform():Matrix3D
		{
			if(isLocalMatrixDirty){
				calcTransform();
				isLocalMatrixDirty = false;
			}
			return localMatrix;
		}
		
		ns_g3d function onUpdate(timeElapsed:int, parentWorldMatrix:Matrix3D):void
		{
			dispatchEvent(new Event(Event.ENTER_FRAME));
			
			worldMatrix.copyFrom(transform);
			if(parentWorldMatrix){
				worldMatrix.append(parentWorldMatrix);
			}
			
			for(var child:Object3D=firstChild; child; child=child.nextSibling){
				child.onUpdate(timeElapsed, worldMatrix);
			}
		}
		
		virtual public function preDrawRenderTargets(context3d:IGpuContext):void
		{
			for(var child:Object3D=firstChild; child; child=child.nextSibling){
				if(child.visible){
					child.preDrawRenderTargets(context3d);
				}
			}
		}
		
		public function draw(render3d:Render3D, context3d:IGpuContext):void
		{
			for(var child:Object3D=firstChild; child; child=child.nextSibling){
				if(child.visible){
					child.draw(render3d, context3d);
				}
			}
		}
		/*
		ns_g3d function collectDrawUnit(collector:DrawUnitCollector3D, camera:Camera3D):void
		{
			for(var child:Object3D=firstChild; child; child=child.nextSibling){
				if(child.visible){
					child.collectDrawUnit(collector, camera);
				}
			}
		}
		*/
		final public function testRay(globalRay:Ray, result:Vector.<RayTestInfo>):void
		{
			if(mouseEnabled){
				onTestRay(globalRay, result);
			}
			if(false == mouseChildren){
				return;
			}
			for(var child:Object3D=firstChild; child; child=child.nextSibling){
				if(child.visible){
					child.testRay(globalRay, result);
				}
			}
		}
		
		protected function onTestRay(ray:Ray, result:Vector.<RayTestInfo>):void	{}
		
		ns_g3d function getLocalRay(globalRay:Ray):Ray
		{
			return globalRay.transformToLocal(worldMatrix);
		}
		
		public function addChild(child:Object3D):void
		{
			if(null == child || this == child || this == child.parent){
				return;
			}
			
			if(child.parent){
				child.parent.removeChild(child);
			}
			
			child._parent = this;
			child._nextSibling = firstChild;
			this._firstChild = child;
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
			_scaleX = _scaleY = _scaleZ = val;
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
			return _x;
		}

		public function set x(value:Number):void
		{
			_x = value;
			isLocalMatrixDirty = true;
		}

		public function get y():Number
		{
			return _y;
		}

		public function set y(value:Number):void
		{
			_y = value;
			isLocalMatrixDirty = true;
		}

		public function get z():Number
		{
			return _z;
		}

		public function set z(value:Number):void
		{
			_z = value;
			isLocalMatrixDirty = true;
		}

		public function get scaleX():Number
		{
			return _scaleX;
		}

		public function set scaleX(value:Number):void
		{
			_scaleX = value;
			isLocalMatrixDirty = true;
		}

		public function get scaleY():Number
		{
			return _scaleY;
		}

		public function set scaleY(value:Number):void
		{
			_scaleY = value;
			isLocalMatrixDirty = true;
		}

		public function get scaleZ():Number
		{
			return _scaleZ;
		}

		public function set scaleZ(value:Number):void
		{
			_scaleZ = value;
			isLocalMatrixDirty = true;
		}

		public function get rotationX():Number
		{
			return _rotationX;
		}

		public function set rotationX(value:Number):void
		{
			_rotationX = value;
			isLocalMatrixDirty = true;
		}

		public function get rotationY():Number
		{
			return _rotationY;
		}

		public function set rotationY(value:Number):void
		{
			_rotationY = value;
			isLocalMatrixDirty = true;
		}

		public function get rotationZ():Number
		{
			return _rotationZ;
		}

		public function set rotationZ(value:Number):void
		{
			_rotationZ = value;
			isLocalMatrixDirty = true;
		}
		
		public function get alpha():Number
		{
			return _alpha;
		}
		
		public function set alpha(value:Number):void
		{
			_alpha = value;
		}
		
		public function get opaque():Boolean
		{
			return BlendMode.NORMAL == _blendMode;
		}
		
		public function set opaque(value:Boolean):void
		{
			_blendMode = value ? BlendMode.NORMAL : BlendMode.ALPHAL;
		}
		
		public function get visible():Boolean
		{
			return _visible;
		}
		
		public function set visible(value:Boolean):void
		{
			_visible = value;
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
			this._x = tempPoint.x;
			this._y = tempPoint.y;
			this._z = tempPoint.z;
		}
		
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
		
		public function createChild(childName:String=null, childTypeName:String=null):Object3D
		{
			var child:Object3D = new Object3D(childName, childTypeName);
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