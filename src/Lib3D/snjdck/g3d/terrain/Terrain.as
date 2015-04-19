package snjdck.g3d.terrain
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import array.pushIfNotHas;
	
	import mu.MuMapUtil;
	import mu.MuModelLoader;
	
	import snjdck.fileformat.bmd.BmdParser;
	import snjdck.fileformat.image.BmpParser;
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.mesh.Mesh;
	import snjdck.g3d.obj3d.Entity;
	import snjdck.g3d.pickup.Ray;
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.asset.AssetMgr;
	import snjdck.gpu.asset.GpuAssetFactory;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.IGpuTexture;
	import snjdck.gpu.geom.OBB2;
	import snjdck.gpu.support.QuadRender;
	import snjdck.quadtree.QuadTree;
	
	import stdlib.constant.Unit;
	
	internal class Terrain extends Object3D
	{
		static private var _ins:Terrain;
		static public function get ins():Terrain
		{
			if(null == _ins){
				_ins = new Terrain();
			}
			return _ins;
		}
		
		private var quadTree:QuadTree;
		private var texList:Array = [];
		
		public function Terrain()
		{
			name = "ground";
			area.center = new Vector3D();
			area.rotation = -45 * Unit.RADIAN;
			area.halfWidth = 640;
			area.halfHeight = 720;
			
			readMapObj();
			
			var picList:Array = [
				new PIC_1().bitmapData,//256,grass_1
				new PIC_2().bitmapData,//128,grass_2
				new PIC_3().bitmapData,//256,ground_1
				new PIC_4().bitmapData,//128,ground_2
				new PIC_5().bitmapData,//128,ground_3
				new PIC_8().bitmapData,//256,water_1 == 5
				new PIC_9().bitmapData,//128,wood_1
				new PIC_6().bitmapData,//256,rock_1
				new PIC_7().bitmapData,//128,rock_2
			];
			for each(var bmd:BitmapData in picList){
				texList.push(GpuAssetFactory.CreateGpuTexture2(bmd));
			}
			
			var lightData:BitmapData = new BIN_LIGHT().bitmapData;
			var heightData:BitmapData = new BmpParser(new BIN_HEIGHT()).decode();
//			trace(lightData.rect, heightData.rect);
//			p.addChild(new Bitmap(lightData));
//			p.addChild(new Bitmap(heightData)).x = 300;
			
			var ba:ByteArray = new BIN_MAP();
			ba.position = 1;
			var layer1:Array = readData(ba);
			var layer2:Array = readData(ba);
			var alphaLayer:Array = readData(ba);
			
			quadTree = QuadTree.Create(0x4000, 8);
			for(var i:int=0; i<256; ++i){
				for(var j:int=0; j<256; ++j){
					var item:TerrainQuad = new TerrainQuad();
					var px:int = i*128-0x4000;
					var py:int = j*128-0x4000;
//					item.setValue(0, i*128, j*128, 0, 0, 0, 0, 0);
//					item.setValue(1, i*128, j*128, 0, 0, 0, 0, 0);
//					item.setValue(2, i*128, j*128, 0, 0, 0, 0, 0);
//					item.setValue(3, i*128, j*128, 0, 0, 0, 0, 0);
					item.x = px;
					item.y = py;
					var index:int = j*256+i;
					item.tex0 = texList[layer1[index]];
					item.tex1 = texList[layer2[index]];
					item.alpha = layer2[index] / 0xFF;
					item.setLight(lightData.getPixel32(i, j));
					quadTree.insert(item);
				}
			}
		}
		
		private function readData(ba:ByteArray):Array
		{
			var result:Array = [];
			for(var i:int=0; i<256; i++){
				for(var j:int=0; j<256; j++){
					var byte:int = ba.readUnsignedByte();
					result.push(byte);
				}
			}
			return result;
		}
		
		[Embed(source="C:/Users/Alex/MU1_03H_full(Chs)/data/世界地图/World1/Terrain1.att", mimeType="application/octet-stream")]
		static private const BIN_ATT:Class;
		
		[Embed(source="C:/Users/Alex/MU1_03H_full(Chs)/data/世界地图/World1/Terrain.map", mimeType="application/octet-stream")]
		static private const BIN_MAP:Class;
		
		[Embed(source="C:/Users/Alex/MU1_03H_full(Chs)/data/世界地图/World1/TerrainLight.jpg")]
		static private const BIN_LIGHT:Class;
		
		[Embed(source="C:/Users/Alex/MU1_03H_full(Chs)/data/世界地图/World1/TerrainHeight.bmp", mimeType="application/octet-stream")]
		static private const BIN_HEIGHT:Class;
		
		
		[Embed(source="C:/Users/Alex/MU1_03H_full(Chs)/data/世界地图/World1/TileGrass01.jpg")]
		static private const PIC_1:Class;
		
		[Embed(source="C:/Users/Alex/MU1_03H_full(Chs)/data/世界地图/World1/TileGrass02.jpg")]
		static private const PIC_2:Class;
		
		[Embed(source="C:/Users/Alex/MU1_03H_full(Chs)/data/世界地图/World1/TileGround01.jpg")]
		static private const PIC_3:Class;
		
		[Embed(source="C:/Users/Alex/MU1_03H_full(Chs)/data/世界地图/World1/TileGround02.jpg")]
		static private const PIC_4:Class;
		
		[Embed(source="C:/Users/Alex/MU1_03H_full(Chs)/data/世界地图/World1/TileGround03.jpg")]
		static private const PIC_5:Class;
		
		[Embed(source="C:/Users/Alex/MU1_03H_full(Chs)/data/世界地图/World1/TileRock01.jpg")]
		static private const PIC_6:Class;
		
		[Embed(source="C:/Users/Alex/MU1_03H_full(Chs)/data/世界地图/World1/TileRock02.jpg")]
		static private const PIC_7:Class;
		
		[Embed(source="C:/Users/Alex/MU1_03H_full(Chs)/data/世界地图/World1/TileWater01.jpg")]
		static private const PIC_8:Class;
		
		[Embed(source="C:/Users/Alex/MU1_03H_full(Chs)/data/世界地图/World1/TileWood01.jpg")]
		static private const PIC_9:Class;
		
		public function draw(context3d:GpuContext):void
		{
			context3d.blendMode = BlendMode.NORMAL;
			context3d.program = AssetMgr.Instance.getProgram("terrain_quad");
			var defaultTex:IGpuTexture = AssetMgr.Instance.getTexture("terrain");
			QuadRender.Instance.drawBegin(context3d);
			
			result.length = 0;
			quadTree.getObjectsInArea(area, result);
			trace("quad count:",result.length);
			
			for each(var quad:TerrainQuad in result)
			{
				fcConst[0] = 1 - quad.alpha;
				fcConst[1] = 0.5;
				quad.light.copyTo(fcConst, 4);
				context3d.setFc(0, fcConst);
				context3d.setTextureAt(0, quad.tex0 || defaultTex);
				context3d.setTextureAt(1, quad.tex1 || defaultTex);
				quad.draw(context3d);
			}
		}
		
		public const area:OBB2 = new OBB2();
		private const result:Array = [];
		private const mapSize:Rectangle = new Rectangle(-0x4000, -0x4000, 0x8000, 0x8000);
		
		private const fcConst:Vector.<Number> = new Vector.<Number>(8);
		
		override protected function onHitTest(localRay:Ray):Boolean
		{
			var t:Number = -localRay.pos.z / localRay.dir.z;
			var pos:Vector3D = localRay.getPt(t);
			
			if(mapSize.contains(pos.x, pos.y)){
				mouseLocation.copyFrom(pos);
				return true;
			}
			return false;
		}
		
		[Embed(source="C:/Users/Alex/MU1_03H_full(Chs)/data/世界地图/World1/Terrain.obj", mimeType="application/octet-stream")]
		static private const BIN_MAP_OBJ:Class;
		
		public function readMapObj():void
		{
			var ba:ByteArray = new BIN_MAP_OBJ();
			ba.endian = Endian.LITTLE_ENDIAN;
			ba.position = 1;
			var amount:int = ba.readUnsignedShort();//30个一组
			
			for(var i:int=0; i<amount; i++){
				var objId:int = ba.readUnsignedShort();
				//pos
				var px:Number = ba.readFloat();
				var py:Number = ba.readFloat();
				var pz:Number = ba.readFloat();
				//rotation
				var rx:Number = ba.readFloat();
				var ry:Number = ba.readFloat();
				var rz:Number = ba.readFloat();
				//scale
				var scale:Number = ba.readFloat();
				
//				array.pushIfNotHas(objIdlist, objId);
//				if(px < minX) minX = px;
//				if(px > maxX) maxX = px;
//				if(py < minY) minY = py;
//				if(py > maxY) maxY = py;
//				if(pz < minZ) minZ = pz;
//				if(pz > maxZ) maxZ = pz;
				//				continue;
				
				//				trace("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%", objId, px, py, pz, rx, ry, rz, scale);
				
				var temp:Object3D = new MuModelLoader(objId);
				addChild(temp);
				
				temp.x = px;
				temp.y = py;
				//				temp.z = pz;
				temp.rotationX = rx * Unit.RADIAN;
				temp.rotationY = ry * Unit.RADIAN;
				temp.rotationZ = rz * Unit.RADIAN;
				temp.scale = scale;
				
			}
//			trace(objIdlist.length);
//			trace(objIdlist);
//			trace(minX, maxX);
//			trace(minY, maxY);
//			trace(minZ, maxZ);
		}
	}
}