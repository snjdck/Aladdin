package snjdck.gpu.asset
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filesystem.FileIO;
//	import flash.filesystem.File;
//	import flash.filesystem.FileMode;
//	import flash.filesystem.FileStream;
	import flash.http.loadMedia;
	import flash.system.isAdobeAir;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import dict.deleteKey;
	import dict.hasKey;
	
	import snjdck.fileformat.bmd.BmdParser;
	import snjdck.fileformat.image.BmpParser;
	import snjdck.fileformat.image.TgaParser;
	import snjdck.fileformat.ogre.OgreMeshParser;
	import snjdck.fileformat.ogre.OgreSkeletonParser;
	import snjdck.g3d.mesh.Mesh;
	import snjdck.g3d.skeleton.Skeleton;
	
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
		[Embed(source="/snjdck/shader/shader.agal", mimeType="application/octet-stream")]
		static private const CLS_SHADER_DATA_3D:Class;
		
		[Embed(source="/snjdck/shader/shader2d.agal", mimeType="application/octet-stream")]
		static private const CLS_SHADER_DATA_2D:Class;
		
		[Embed(source="/snjdck/shader/particle.agal", mimeType="application/octet-stream")]
		static private const CLS_SHADER_DATA_PARTICLE:Class;
		
		[Embed(source="/snjdck/shader/terrain.agal", mimeType="application/octet-stream")]
		static private const CLS_SHADER_DATA_TERRAIN:Class;
		
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
			textureDict = new Dictionary();
		}
		
		private function initShaderData(shaderData:String):void
		{
			var pattern:RegExp = /@(?P<name>[.\w]+)(|<(?P<args>[^\s]+)>)\s+(?P<code>.+?)(?=@|$)/gs;
			var obj:Array;
			var shaderName:String;
			
			for(;;){
				obj = pattern.exec(shaderData);
				if(null == obj){
					break;
				}
				shaderName = obj.name;
				if(shaderName in shaderDict){
					throw new Error(replace("shader name '${0}' has been used!", [shaderName]));
				}
				var shaderCode:String = replace(obj.code, shaderDict);
				if(Boolean(obj.args)){
					shaderCode = replace(shaderCode, obj.args.split(","));
				}
				shaderDict[shaderName] = shaderCode;
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
			var index:int = shaderCode.search(/\n.*?(fs|ft|fc|oc|kil)/);
			
			var vertexProgram:Array = splitByLine(trim(shaderCode.slice(0, index)));
			var fragmentProgram:Array = splitByLine(trim(shaderCode.slice(index)));
			
			programDict[shaderName] = GpuAssetFactory.CreateGpuProgram(vertexProgram, fragmentProgram);
		}
		
		public function getProgram(name:String):GpuProgram
		{
			if(null == programDict){
				programDict = {};
				initShaderData(new CLS_SHADER_DATA_2D().toString());
				initShaderData(new CLS_SHADER_DATA_3D().toString());
				initShaderData(new CLS_SHADER_DATA_PARTICLE().toString());
				initShaderData(new CLS_SHADER_DATA_TERRAIN().toString());
			}
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
		
//		private var fs:FileStream = new FileStream();
		
		public function getTexture(name:String):IGpuTexture
		{
			if(!hasTexture(name)){
				showError(name);
			/*
				var file:File;
				for each(var path:String in searchPathList){
					file = new File(path + name);
					if(file.exists){
						var bin:ByteArray = new ByteArray();
						fs.open(file, FileMode.READ);
						fs.readBytes(bin);
						fs.close();
//						var bin:ByteArray = FileIO2.Read(file);
						switch(FileIO.GetExt(file.name)){
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
		
		public function regMesh(name:String, mesh:Mesh):void
		{
			fileDict[name] = mesh;
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
//			trace("资源'" + text + "'未注册!");
			//throw new Error("资源'" + text + "'未注册!");
		}
	}
}