package snjdck.g3d.core
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.signals.Signal;
	
	import snjdck.g3d.Scene3D;
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.pickup.Ray;
	import snjdck.g3d.render.DrawUnitCollector3D;
	import snjdck.gpu.BlendMode;
	
	use namespace ns_g3d;
	
	public class Object3D extends Transform3D
	{
		ns_g3d var _parent:DisplayObjectContainer3D;
		ns_g3d var _scene:Scene3D;
		ns_g3d var _root:DisplayObjectContainer3D;
		
		public var id:int;
		public var name:String;
		public var userData:*;
		
		public var mouseEnabled:Boolean;
		
		private var _blendMode:BlendMode;
		public var visible:Boolean;
		
		public const mouseDownSignal:Signal = new Signal();
		public const mouseLocation:Vector3D = new Vector3D();
		
		public function Object3D()
		{
			visible = true;
			mouseEnabled = true;
			_blendMode = BlendMode.NORMAL;
		}
		
		override protected function get parentWorldTransform():Matrix3D
		{
			if(parent == null){
				return null;
			}
			return parent.worldTransform;
		}
		
		public function onUpdate(timeElapsed:int):void{}
		ns_g3d function collectDrawUnit(collector:DrawUnitCollector3D):void{}
		
		public function hitTest(worldRay:Ray, result:Vector.<Object3D>):void
		{
			if(mouseEnabled){
				worldRay.transform(worldTransformInvert, tempRay);
				if(onHitTest(tempRay)){
					result.push(this);
				}
			}
		}
		
		virtual protected function onHitTest(localRay:Ray):Boolean
		{
			return false;
		}
		
		override public function isVisible():Boolean
		{
			return visible && super.isVisible();
		}
		
		public function get parent():DisplayObjectContainer3D
		{
			return _parent;
		}

		public function get blendMode():BlendMode
		{
			return _blendMode;
		}

		public function set blendMode(value:BlendMode):void
		{
			_blendMode = value;
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
		/*
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
		//*/
		final public function get scene():Scene3D
		{
			var target:Object3D = this;
			for(;;){
				if(target._scene != null){
					return target._scene;
				}
				if(null == target._parent){
					return null;
				}
				target = target._parent;
			}
			return null;
		}
		
		final public function get root():DisplayObjectContainer3D
		{
			var target:Object3D = this;
			for(;;){
				if(target._root != null){
					return target._root;
				}
				if(null == target._parent){
					return null;
				}
				target = target._parent;
			}
			return null;
		}
		
		protected const tempRay:Ray = new Ray();
	}
}