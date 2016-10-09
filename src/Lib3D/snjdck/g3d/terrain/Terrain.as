package snjdck.g3d.terrain
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import mu.MuModelLoader;
	
	import snjdck.fileformat.image.BmpParser;
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.entities.IEntity;
	import snjdck.g3d.pickup.Ray;
	import snjdck.g3d.render.DrawUnitCollector3D;
	import snjdck.g3d.render.IDrawUnit3D;
	import snjdck.g3d.rendersystem.subsystems.RenderPriority;
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.asset.AssetMgr;
	import snjdck.gpu.asset.GpuAssetFactory;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.IGpuTexture;
	import snjdck.quadtree.QuadTree;
	import snjdck.shader.ShaderName;
	
	import stdlib.constant.Unit;
	
	use namespace ns_g3d;
	
	public class Terrain extends Object3D implements IDrawUnit3D
	{
		private var quadTree:QuadTree;
		private var texList:Array = [];
		
		internal var layer1:Array;
		internal var layer2:Array;
		internal var alphaLayer:Array;
		
		public function Terrain()
		{
			blendMode = BlendMode.NORMAL;
			name = "ground";
			/*
			area.center = new Vector3D();
			area.rotation = -45 * Unit.RADIAN;
			area.halfWidth = 640;
			area.halfHeight = 720;
			*/
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
			
			var defaultTex:IGpuTexture = AssetMgr.Instance.getTexture("terrain");
			var lightData:BitmapData = new BIN_LIGHT().bitmapData;
			var heightData:BitmapData = new BmpParser(new BIN_HEIGHT()).decode();
//			p.addChild(new Bitmap(lightData));
//			p.addChild(new Bitmap(heightData)).x = 300;
			
			var ba:ByteArray = new BIN_MAP();
			ba.position = 1;
			layer1 = readData(ba);
			layer2 = readData(ba);
			alphaLayer = readData(ba);
			/*
			var fuck:Array = [];
			for(var i:int=0; i<0x10000; ++i){
				fuck[i] = layer1[i] | (layer2[i] << 8);
			}
			for(var i:int=0; i<0x100; ++i){
				var str:Array = [];
				for(var j:int=0; j<0x100; ++j){
					str.push(fuck[i*0x100+j].toString(16));
				}
				trace(str.join("\t"));
			}
			*/
			quadTree = new QuadTree(null, 0, 0, 0x4000, 128);
			for(var i:int=0; i<256; ++i){
				for(var j:int=0; j<256; ++j){
					var index:int = j*256+i;
					var item:TerrainQuad = new TerrainQuad(this);
					item.setValue(i, j, alphaLayer, lightData);
					item.tex0 = texList[layer1[index]] || defaultTex;
					item.tex1 = texList[layer2[index]] || defaultTex;
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
		
		[Embed(source="F:/ProgramData/MU1_03H_full(Chs)/data/世界地图/World1/Terrain1.att", mimeType="application/octet-stream")]
		static private const BIN_ATT:Class;
		
		[Embed(source="F:/ProgramData/MU1_03H_full(Chs)/data/世界地图/World1/Terrain.map", mimeType="application/octet-stream")]
		static private const BIN_MAP:Class;
		
		[Embed(source="F:/ProgramData/MU1_03H_full(Chs)/data/世界地图/World1/TerrainLight.jpg")]
		static private const BIN_LIGHT:Class;
		
		[Embed(source="F:/ProgramData/MU1_03H_full(Chs)/data/世界地图/World1/TerrainHeight.bmp", mimeType="application/octet-stream")]
		static private const BIN_HEIGHT:Class;
		
		
		[Embed(source="F:/ProgramData/MU1_03H_full(Chs)/data/世界地图/World1/TileGrass01.jpg")]
		static private const PIC_1:Class;
		
		[Embed(source="F:/ProgramData/MU1_03H_full(Chs)/data/世界地图/World1/TileGrass02.jpg")]
		static private const PIC_2:Class;
		
		[Embed(source="F:/ProgramData/MU1_03H_full(Chs)/data/世界地图/World1/TileGround01.jpg")]
		static private const PIC_3:Class;
		
		[Embed(source="F:/ProgramData/MU1_03H_full(Chs)/data/世界地图/World1/TileGround02.jpg")]
		static private const PIC_4:Class;
		
		[Embed(source="F:/ProgramData/MU1_03H_full(Chs)/data/世界地图/World1/TileGround03.jpg")]
		static private const PIC_5:Class;
		
		[Embed(source="F:/ProgramData/MU1_03H_full(Chs)/data/世界地图/World1/TileRock01.jpg")]
		static private const PIC_8:Class;
		
		[Embed(source="F:/ProgramData/MU1_03H_full(Chs)/data/世界地图/World1/TileRock02.jpg")]
		static private const PIC_9:Class;
		
		[Embed(source="F:/ProgramData/MU1_03H_full(Chs)/data/世界地图/World1/TileWater01.jpg")]
		static private const PIC_6:Class;
		
		[Embed(source="F:/ProgramData/MU1_03H_full(Chs)/data/世界地图/World1/TileWood01.jpg")]
		static private const PIC_7:Class;
		
		public function draw(context3d:GpuContext):void
		{
		}
		
		//public const area:OBB2 = new OBB2();
		private const result:Array = [];
		private const mapSize:Rectangle = new Rectangle(0, -25000, 25000, 25000);
//		private const mapSize:Rectangle = new Rectangle(0, -0x8000, 0x8000, 0x8000);
		
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
		
		[Embed(source="F:/ProgramData/MU1_03H_full(Chs)/data/世界地图/World1/Terrain.obj", mimeType="application/octet-stream")]
		static private const BIN_MAP_OBJ:Class;
		
		private const itemList:Vector.<IEntity> = new Vector.<IEntity>();
		
		private function readMapObj():void
		{
			var minX:Number=Number.MAX_VALUE, maxX:Number=Number.MIN_VALUE;
			var minY:Number=Number.MAX_VALUE, maxY:Number=Number.MIN_VALUE;
			var minZ:Number=Number.MAX_VALUE, maxZ:Number=Number.MIN_VALUE;
			
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
				if(px < minX) minX = px;
				if(px > maxX) maxX = px;
				if(py < minY) minY = py;
				if(py > maxY) maxY = py;
				if(pz < minZ) minZ = pz;
				if(pz > maxZ) maxZ = pz;
				//				continue;
				
				//				trace("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%", objId, px, py, pz, rx, ry, rz, scale);
				
				var temp:MuModelLoader = new MuModelLoader(objId, addEntity);
				
				temp.x = px;
				temp.y = -py;
				temp.z = pz;
				//				temp.z = pz;
				temp.rotationX = rx * Unit.RADIAN;
				temp.rotationY = ry * Unit.RADIAN;
				temp.rotationZ = rz * Unit.RADIAN;
				temp.scale = scale;
				
			}
			trace("场景内物体数量:",itemList.length);
//			trace(objIdlist);
			trace(minX, maxX);
			trace(minY, maxY);
			trace(minZ, maxZ);
		}
		
		public function addEntity(entity:IEntity):void
		{
			var sceneItem:SceneItem = new SceneItem(entity);
			(sceneItem.entity as Object3D)._scene = this.scene;
			quadTree.insert(sceneItem);
			itemList.push(entity);
		}
		/*
		private var min:Vector3D = new Vector3D(int.MAX_VALUE, int.MAX_VALUE, int.MAX_VALUE);
		private var max:Vector3D = new Vector3D(int.MIN_VALUE, int.MIN_VALUE, int.MIN_VALUE);
		
		private function __onEntityLoad(entity:Entity):void
		{
			var sceneItem:SceneItem = new SceneItem(entity);
			quadTree.insert(sceneItem);
			itemList.push(entity);
			
			if(sceneItem.bound.minX < min.x){
				min.x = sceneItem.bound.minX;
			}
			if(sceneItem.bound.minY < min.y){
				min.y = sceneItem.bound.minY;
			}
			if(sceneItem.bound.minZ < min.z){
				min.z = sceneItem.bound.minZ;
			}
			if(sceneItem.bound.maxX > max.x){
				max.x = sceneItem.bound.maxX;
			}
			if(sceneItem.bound.maxY > max.y){
				max.y = sceneItem.bound.maxY;
			}
			if(sceneItem.bound.maxZ > max.z){
				max.z = sceneItem.bound.maxZ;
			}
			
		}
		*/
		
		override public function onUpdate(timeElapsed:int):void
		{
			/*
			for each(var item:Entity in itemList){
				item.updateBoneState(timeElapsed);
			}
			*/
		}
		
		override ns_g3d function collectDrawUnit(collector:DrawUnitCollector3D):void
		{
			result.length = 0;
			quadTree.getObjectsInFrustum(scene.camera.getViewFrustum(), result);
			
			for(var i:int=result.length-1; i>=0; --i){
				var sceneItem:SceneItem = result[i] as SceneItem;
				if(sceneItem != null){
					(sceneItem.entity as Object3D).collectDrawUnit(collector);
				}
				if(result[i] is TerrainQuad){
					collector.addItem(result[i], RenderPriority.TERRAIN);
				}
			}
			collector.addItem(this, RenderPriority.STATIC_OBJECT);
//			trace(min, max);
		}
	}
}