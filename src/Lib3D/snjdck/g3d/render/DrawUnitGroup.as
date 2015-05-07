package snjdck.g3d.render
{
	import array.push;
	
	import dict.hasKey;
	
	import snjdck.g3d.core.Camera3D;
	import snjdck.gpu.asset.AssetMgr;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.shader.ShaderName;

	internal class DrawUnitGroup
	{
		private const staticObjectList:Vector.<IDrawUnit3D> = new Vector.<IDrawUnit3D>();
		private const terrainList:Vector.<IDrawUnit3D> = new Vector.<IDrawUnit3D>();
		private const drawUnitDict:Object = {};
		private var count:int;
		
		public function DrawUnitGroup(){}
		
		public function draw(context3d:GpuContext, camera3d:Camera3D, updateBlendMode:Boolean):void
		{
			var drawUnit:IDrawUnit3D;
			for(var shaderName:String in drawUnitDict){
				var drawUnitList:Vector.<IDrawUnit3D> = drawUnitDict[shaderName];
				if(drawUnitList.length <= 0){
					continue;
				}
				context3d.program = AssetMgr.Instance.getProgram(shaderName);
				for each(drawUnit in drawUnitList){
					if(updateBlendMode){
						context3d.blendMode = drawUnit.blendMode;
					}
					drawUnit.draw(context3d, camera3d);
				}
			}
			if(staticObjectList.length > 0){
				context3d.program = AssetMgr.Instance.getProgram(ShaderName.STATIC_OBJECT);
				for each(drawUnit in staticObjectList){
					if(updateBlendMode){
						context3d.blendMode = drawUnit.blendMode;
					}
					drawUnit.draw(context3d, camera3d);
				}
			}
			if(terrainList.length > 0){
				context3d.program = AssetMgr.Instance.getProgram(ShaderName.TERRAIN);
				for each(drawUnit in terrainList){
					drawUnit.draw(context3d, camera3d);
				}
			}
		}
		
		public function hasDrawUnits():Boolean
		{
			return count > 0;
		}
		
		public function cullInvisibleUnits(camera:Camera3D):void
		{
			camera.cullInvisibleUnits(staticObjectList);
			camera.cullInvisibleUnits(terrainList);
			for each(var drawUnitList:Vector.<IDrawUnit3D> in drawUnitDict){
				camera.cullInvisibleUnits(drawUnitList);
			}
		}
		
		public function addDrawUnit(drawUnit:IDrawUnit3D):void
		{
			switch(drawUnit.shaderName)
			{
				case ShaderName.STATIC_OBJECT:
					push(staticObjectList, drawUnit);
					break;
				case ShaderName.TERRAIN:
					push(terrainList, drawUnit);
					break;
				default:
					push(getDrawUnits(drawUnit.shaderName), drawUnit);
			}
			++count;
		}
		
		public function clear():void
		{
			staticObjectList.length = 0;
			terrainList.length = 0;
			for each(var drawUnitList:Vector.<IDrawUnit3D> in drawUnitDict){
				drawUnitList.length = 0;
			}
			count = 0;
		}
		
		public function getStaticDrawUnits():Vector.<IDrawUnit3D>
		{
			return staticObjectList;
		}
		
		private function getDrawUnits(shaderName:String):Vector.<IDrawUnit3D>
		{
			if(!hasKey(drawUnitDict, shaderName)){
				drawUnitDict[shaderName] = new Vector.<IDrawUnit3D>();
			}
			return drawUnitDict[shaderName];
		}
	}
}