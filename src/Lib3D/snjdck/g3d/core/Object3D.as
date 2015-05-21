package snjdck.g3d.core
{
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.signals.Signal;
	
	import matrix33.decompose;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.pickup.Ray;
	import snjdck.g3d.render.DrawUnitCollector3D;
	import snjdck.g3d.render.MatrixStack3D;
	import snjdck.gpu.BlendMode;
	
	use namespace ns_g3d;
	
	public class Object3D
	{
		ns_g3d var _parent:DisplayObjectContainer3D;
		
		private const _position:Vector3D = new Vector3D();
		private const _rotation:Vector3D = new Vector3D();
		private const _scale:Vector3D = new Vector3D(1, 1, 1);
		private const matrixComponents:Vector.<Vector3D> = new <Vector3D>[_position,_rotation,_scale];
		
		private var isLocalMatrixDirty:Boolean;
		ns_g3d const localMatrix:Matrix3D = new Matrix3D();
		
		ns_g3d const prevWorldMatrix:Matrix3D = new Matrix3D();
		
		public var visible:Boolean;
		public var name:String;
		
		public var mouseEnabled:Boolean;
		
		private var _blendMode:BlendMode;
		
		public const mouseDownSignal:Signal = new Signal();
		public const mouseLocation:Vector3D = new Vector3D();
		
		public function Object3D()
		{
			visible = true;
			mouseEnabled = true;
		}
		
		public function get transform():Matrix3D
		{
			if(isLocalMatrixDirty){
				localMatrix.recompose(matrixComponents);
				isLocalMatrixDirty = false;
			}
			return localMatrix;
		}
		
		public function onUpdate(matrixStack:MatrixStack3D, timeElapsed:int):void
		{
			matrixStack.pushMatrix(transform);
			prevWorldMatrix.copyFrom(matrixStack.worldMatrix);
			matrixStack.popMatrix();
		}
		
		ns_g3d function collectDrawUnit(collector:DrawUnitCollector3D, camera3d:Camera3D):void{}
		
		public function hitTest(ray:Ray, result:Vector.<Object3D>):void
		{
			if(mouseEnabled){
				ray.transformInv(transform, tempRay);
				if(onHitTest(tempRay)){
					result.push(this);
				}
			}
		}
		
		virtual protected function onHitTest(localRay:Ray):Boolean
		{
			return false;
		}
		
		public function hasVisibleArea():Boolean
		{
			return visible && (_scale.x != 0) && (_scale.y != 0) && (_scale.z != 0);
		}
		
		
		/*
		public function get scene():Scene3D
		{
			return parent ? parent.scene : null;
		}
		*/
		public function get parent():DisplayObjectContainer3D
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
		//--------------------------util methods---------------------
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
		
		protected const tempRay:Ray = new Ray();
		static private const tempPoint:Vector3D = new Vector3D();
		static private const tempMatrix:Matrix3D = new Matrix3D();
		
		ns_g3d function syncMatrix2D(matrix2d:Matrix):void
		{
			matrix33.decompose(matrix2d, _position, _scale, _rotation);
			isLocalMatrixDirty = true;
		}
	}
}