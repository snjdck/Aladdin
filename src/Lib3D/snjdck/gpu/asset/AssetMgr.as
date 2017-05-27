package snjdck.gpu.asset
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filesystem.FileIO;
	import flash.http.loadMedia;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
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
	import string.replace2;
	import string.splitByLine;
	import string.trim;

	public class AssetMgr
	{
		[Embed(source="/snjdck/shader/shader3d.agal", mimeType="application/octet-stream")]
		static private const CLS_SHADER_DATA_3D:Class;
		
		[Embed(source="/snjdck/shader/shader2d.agal", mimeType="application/octet-stream")]
		static private const CLS_SHADER_DATA_2D:Class;
		
		[Embed(source="/snjdck/shader/filter2d.agal", mimeType="application/octet-stream")]
		static private const CLS_SHADER_FILTER_2D:Class;
		
		[Embed(source="/snjdck/shader/particle2d.agal", mimeType="application/octet-stream")]
		static private const CLS_SHADER_DATA_PARTICLE:Class;
		
		[Embed(source="/snjdck/shader/terrain.agal", mimeType="application/octet-stream")]
		static private const CLS_SHADER_DATA_TERRAIN:Class;
		
		[Embed(source="/snjdck/shader/text2d.agal", mimeType="application/octet-stream")]
		static private const CLS_SHADER_DATA_TEXT_2D:Class;
		
		[Embed(source="/snjdck/shader/polygon2d.agal", mimeType="application/octet-stream")]
		static private const CLS_SHADER_DATA_POLYGON_2D:Class;
		
		[Embed(source="/snjdck/shader/deferred_rendering.agal", mimeType="application/octet-stream")]
		static private const CLS_SHADER_DATA_DEFERRED_RENDERING:Class;
		
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
				var shaderCode:String = replace2(obj.code, shaderDict);
//				if(Boolean(obj.args)){
//					shaderCode = replace(shaderCode, obj.args.split(","));
//				}
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
			
			var program:GpuProgram = GpuAssetFactory.CreateGpuProgram(vertexProgram, fragmentProgram);
			program.name = shaderName;
			programDict[shaderName] = program;
		}
		
		public function getProgram(name:String):GpuProgram
		{
			if(null == programDict){
				programDict = {};
				initShaderData(new CLS_SHADER_DATA_2D().toString());
				initShaderData(new CLS_SHADER_DATA_3D().toString());
				initShaderData(new CLS_SHADER_FILTER_2D().toString());
				initShaderData(new CLS_SHADER_DATA_PARTICLE().toString());
				initShaderData(new CLS_SHADER_DATA_TERRAIN().toString());
				initShaderData(new CLS_SHADER_DATA_TEXT_2D().toString());
				initShaderData(new CLS_SHADER_DATA_POLYGON_2D().toString());
				initShaderData(new CLS_SHADER_DATA_DEFERRED_RENDERING().toString());
			}
			return programDict[name];
		}
		
		public function regTexture(name:String, texture:*):void
		{
//			if(hasTexture(name)){
//				trace("texture '" + name + "' has reg!");
//			}else{
			var isOpaque:Boolean = FileIO.GetExt(name) == "tga";
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
				texture.isOpaque = isOpaque;
				textureDict[name] = texture;
			}else{
				throw new Error("error input!");
			}
//			}
		}
		
		public function delTexture(name:String):void
		{
			getTexture(name).dispose();
			$dict.deleteKey(textureDict, name);
		}
		
		public function hasTexture(name:String):Boolean
		{
			return $dict.hasKey(textureDict, name);
		}
		
		public function getTexture(name:String):IGpuTexture
		{
			if(hasTexture(name)){
				return textureDict[name];
			}
			return GpuAssetFactory.DefaultGpuTexture;
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
			if(!$dict.hasKey(fileDict, name)){
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
		
		public function regTexture2(fileName:String, fileBytes:ByteArray):void
		{
			switch(FileIO.GetExt(fileName)){
				case "tga":
					regTexture(fileName, GpuAssetFactory.CreateGpuTexture2(new TgaParser(fileBytes).decode()));
					break;
				case "bmp":
					regTexture(fileName, GpuAssetFactory.CreateGpuTexture2(new BmpParser(fileBytes).decode()));
					break;
				case "jpg":
				case "png":
				case "gif":
					loadMedia(fileBytes, [__onTextureDataLoad, fileName]);
					break;
				default:
					throw new Error("unsupport file format!");
			}
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