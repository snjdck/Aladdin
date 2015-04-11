package mu
{
	import flash.debugger.enterDebugger;
	import flash.http.loadData;
	import flash.support.Http;
	import flash.utils.ByteArray;
	
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.mesh.Mesh;
	import snjdck.g3d.obj3d.Entity;
	import snjdck.gpu.asset.helper.AssetMgr;
	
	public class MuModelLoader extends Object3D
	{
		public var prefix:String = "data/世界地图/Object1/";
		public var objId:int;
		public var mapId:int;
		
		public function MuModelLoader(objId:int)
		{
			this.objId = objId;
			
			MuLoad.Instance.load(fullPath, __onLoad);
		}
		
		private function get fullPath():String
		{
			return prefix + MuMapUtil.getObjById(objId) + ".bmd";
		}
		
		private function __onLoad(obj:Entity):void
		{
			addChild(obj);
		}
	}
}