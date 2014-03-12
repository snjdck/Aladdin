package snjdck.g3d.asset.helper
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import dict.deleteKey;
	import dict.hasKey;
	
	import flash.http.loadMedia;
	
	import snjdck.fileformat.image.BmpParser;
	import snjdck.fileformat.image.TgaParser;
	import snjdck.g3d.asset.IGpuProgram;
	import snjdck.g3d.asset.IGpuTexture;
	import snjdck.g3d.asset.impl.GpuAssetFactory;
	import snjdck.g3d.mesh.Mesh;
	import snjdck.fileformat.bmd.BmdParser;
	import snjdck.fileformat.ogre.OgreMeshParser;
	import snjdck.fileformat.ogre.OgreSkeletonParser;
	import snjdck.g3d.skeleton.Skeleton;
	
	import flash.filesystem.FileIO2;
	
	import string.has;
	import string.removeComments;
	import string.replace;
	import string.splitByLine;
	import string.trim;

	/**
	 * va0 - pos
	 * va1 - normal
	 * va2 - uv
	 * va4 - boneId1
	 * va5 - boneWeight1
	 * va6 - boneId2
	 * va7 - boneWeight2
	 * 
	 * v0 - uv
	 * v1 - world normal
	 * v2 - light space pos
	 * 
	 * vt0 - 临时
	 * vt1 - 局部pos
	 * vt2 - 局部normal
	 * vt3 - 世界pos
	 * vt4 - 世界normal
	 * vt5 - 投影pos
	 * vt6 - 投影normal
	 * 
	 * vc0	#世界变换矩阵
	 * vc4	#相机变换投影矩阵
	 * vc8	#光照变换投影矩阵
	 * 
	 * vc20 - vc127 : 骨骼矩阵
	 */
	public class AssetMgr
	{
		[Embed(source="shader.agal", mimeType="application/octet-stream")]
		static private const CLS_SHADER_DATA:Class;
		
		static public const Instance:AssetMgr = new AssetMgr();
		
		private var searchPathList:Array;
		
		private var shaderDict:Object;
		private var fileDict:Object;
		private var programDict:Object;
		private var textureDict:Object;
		
		public function AssetMgr()
		{
			searchPathList = [];
			
			shaderDict = {};
			fileDict = new Dictionary();
			programDict = {};
			textureDict = new Dictionary();
			
			initShaderData(new CLS_SHADER_DATA().toString());
		}
		
		private function initShaderData(shaderData:String):void
		{
			var pattern:RegExp = /@([.\w]+)\s+(.+?)(?=@|$)/gs;
			var obj:Array;
			var shaderName:String;
			
			while(true){
				obj = pattern.exec(shaderData);
				if(obj){
					shaderName = obj[1];
					if(shaderName in shaderDict){
						throw new Error(replace("shader name '${0}' has been used!", [shaderName]));
					}
					shaderDict[shaderName] = replace(obj[2], shaderDict);
				}else{
					break;
				}
			}
			
			for(shaderName in shaderDict){
				if(!has(shaderName, ".")){
					regProgram(shaderName);
				}
			}
		}
		
		public function addSearchPath(path:String):void
		{
			searchPathList.push(path);
		}
		
		public function getSkeleton(name:String):Skeleton
		{
			if(fileDict[name] is ByteArray){
				fileDict[name] = OgreSkeletonParser.Parse(fileDict[name]);
			}
			return fileDict[name];
		}
		
		private function regProgram(shaderName:String):void
		{
			var shaderCode:String = removeComments(shaderDict[shaderName]);
			var index:int = shaderCode.search(/\r\n.*?(fs|ft|fc|oc|kil)/);
			
			var vertexProgram:Array = splitByLine(trim(shaderCode.slice(0, index)));
			var fragmentProgram:Array = splitByLine(trim(shaderCode.slice(index)));
			
			programDict[shaderName] = GpuAssetFactory.CreateGpuProgram(vertexProgram, fragmentProgram);
		}
		
		public function getProgram(name:String):IGpuProgram
		{
			return programDict[name];
		}
		
		public function regTexture(name:String, texture:*):void
		{
//			if(hasTexture(name)){
//				trace("texture '" + name + "' has reg!");
//			}else{
			if(texture is Class){
				texture = new texture();
			}
			if(texture is Bitmap){
				texture = texture.bitmapData;
			}
			if(texture is BitmapData){
				texture = GpuAssetFactory.CreateGpuTexture2(texture);
			}
			if(texture is IGpuTexture){
//				textureDict.add(name, texture);
				textureDict[name] = texture;
			}else{
				throw new Error("error input!");
			}
//			}
		}
		
		public function delTexture(name:String):void
		{
			getTexture(name).dispose();
//			textureDict.del(name);
			deleteKey(textureDict, name);
		}
		
		public function hasTexture(name:String):Boolean
		{
//			return textureDict.has(name);
			return hasKey(textureDict, name);
		}
		
		public function getTexture(name:String):IGpuTexture
		{
			if(!hasTexture(name)){
				showError(name);
			/*
				var file:File;
				for each(var path:String in searchPathList){
					file = new File(path + name);
					if(file.exists){
						var bin:ByteArray = FileIO.Read(file);
						switch(file.extension){
							case "tga":
								regTexture(name, GpuAssetFactory.CreateGpuTexture2(new TgaParser(bin).decode()));
								break;
							case "bmp":
								regTexture(name, GpuAssetFactory.CreateGpuTexture2(new BmpParser(bin).decode()));
								break;
							case "jpg":
							case "png":
							case "gif":
								loadMedia(bin, [__onTextureDataLoad, name]);
//								Http.LoadModule(bin, [__onTextureDataLoad, name]);
								return GpuAssetFactory.DefaultGpuTexture;
								break;
								
						}
						return getTexture(name);
					}
				}
			//*/
				return GpuAssetFactory.DefaultGpuTexture;
			}
			return textureDict[name];
		}
		
		public function regFile(name:String, binCls:*):void
		{
			if(binCls is Class){
				binCls = new binCls();
			}
			fileDict[name] = binCls;
		}
		
		public function getFile(name:String):ByteArray
		{
//			if(!fileDict.has(name)){
			if(!hasKey(fileDict, name)){
				showError(name);
				/*
				var file:File;
				for each(var path:String in searchPathList){
					file = new File(path + name);
					if(file.exists){
						return FileUtil.ReadFileImp(file);
					}
				}
				//*/
			}
			return fileDict[name];
		}
		
		public function regMuMesh(name:String, binCls:*):void
		{
			if(binCls is Class){
				binCls = new binCls();
			}
			fileDict[name] = BmdParser.Parse(binCls);
		}
		
		public function regOgreMesh(name:String, binCls:*):void
		{
			if(binCls is Class){
				binCls = new binCls();
			}
			fileDict[name] = OgreMeshParser.Parse(binCls);
		}
		
		public function getMesh(name:String):Mesh
		{
			return fileDict[name];
		}
		
		private function __onTextureDataLoad(ok:Boolean, data:Bitmap, name:String):void
		{
			if(ok){
				regTexture(name, GpuAssetFactory.CreateGpuTexture2(data.bitmapData));
			}else{
				throw new Error("texture load error!");
			}
		}
		
		private function showError(text:String):void
		{
			trace("资源'" + text + "'未注册!");
			//throw new Error("资源'" + text + "'未注册!");
		}
	}
}