package mu
{
	import snjdck.g3d.obj3d.Entity;

	public class MuModelLoader
	{
		public var prefix:String = "data/世界地图/Object1/";
		public var objId:int;
		public var mapId:int;
		
		private var callback:Function;
		
		public var x:Number;
		public var y:Number;
		public var z:Number;
		
		public var rotationX:Number;
		public var rotationY:Number;
		public var rotationZ:Number;
		public var scale:Number;
		
		public function MuModelLoader(objId:int, callback:Function)
		{
			this.objId = objId;
			this.callback = callback;
			MuLoad.Instance.load(fullPath, __onLoad);
		}
		
		private function get fullPath():String
		{
			return prefix + MuMapUtil.getObjById(objId) + ".bmd";
		}
		
		private function __onLoad(entity:Entity):void
		{
			entity.x = x;
			entity.y = -y;
			entity.rotationX = rotationX;
			entity.rotationY = rotationY;
			entity.rotationZ = rotationZ;
			entity.scale = scale;
			entity.calculateBound();
			callback(entity);
		}
	}
}