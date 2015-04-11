package mu
{
	import flash.debugger.enterDebugger;
	import flash.display.Bitmap;
	import flash.filesystem.FileIO;
	import flash.http.loadMedia;
	import flash.support.Http;
	import flash.utils.ByteArray;
	
	import snjdck.fileformat.bmd.BmdParser;
	import snjdck.fileformat.image.BmpParser;
	import snjdck.fileformat.image.TgaParser;
	import snjdck.g3d.mesh.Mesh;
	import snjdck.gpu.asset.GpuAssetFactory;
	import snjdck.gpu.asset.helper.AssetMgr;

	public class MuLoad
	{
		static public const Instance:MuLoad = new MuLoad();
		
		private const stateDict:Object = {};
		
		public function MuLoad()
		{
		}
		
		public function load(path:String, callback:Function):void
		{
			if(!stateDict.hasOwnProperty(path)){
				stateDict[path] = [callback];
				Http.Get(path, null, [__onLoad, path]);
				return;
			}
			var callbackList:Array = stateDict[path];
			if(null == callbackList){
				var mesh:Mesh = AssetMgr.Instance.getMesh(path);
				callback(mesh.createEntity());
			}else{
				callbackList.push(callback);
			}
		}
		
		private function __onLoad(ok:Boolean, bytes:ByteArray, path:String):void
		{
			if(false == ok){
				enterDebugger();
			}
			var mesh:Mesh = BmdParser.Parse(bytes);
			AssetMgr.Instance.regMesh(path, mesh);
			
			var callbackList:Array = stateDict[path];
			stateDict[path] = null;
			for each(var callback:Function in callbackList){
				callback(mesh.createEntity());
			}
			//load textures
			for each(var textureName:String in mesh.getTextureNames()){
				Http.Get(FileIO.GetDirPath(path) + textureName, null, [__onTextureLoad, textureName]);
			}
		}
		
		private function __onTextureLoad(ok:Boolean, bin:ByteArray, name:String):void
		{
			if(false == ok){
				enterDebugger();
				return;
			}
			switch(FileIO.GetExt(name)){
				case "tga":
					AssetMgr.Instance.regTexture(name, GpuAssetFactory.CreateGpuTexture2(new TgaParser(bin).decode()));
					break;
				case "bmp":
					AssetMgr.Instance.regTexture(name, GpuAssetFactory.CreateGpuTexture2(new BmpParser(bin).decode()));
					break;
				case "jpg":
				case "png":
				case "gif":
					loadMedia(bin, [__onTextureDataLoad, name]);
					break;
			}
		}
		
		private function __onTextureDataLoad(ok:Boolean, data:Bitmap, name:String):void
		{
			if(ok){
				AssetMgr.Instance.regTexture(name, GpuAssetFactory.CreateGpuTexture2(data.bitmapData));
			}else{
				throw new Error("texture load error!");
			}
		}
	}
}