package snjdck.g3d.geom
{
	import flash.geom.Vector3D;
	
	public class Particle
	{
		public var startTime:Number = 0;
		
		public var life:Number;//生命
//		public var age:Number;
		
		public var pos:Vector3D;
		public var speed:Vector3D;
		public var acc:Vector3D;
		
		public var beginSize:Number;//开始大小
		public var endSize:Number;//结束大小
		
		public var beginColor:Vector3D;
		public var endColor:Vector3D;

//		public var decay:Number;//衰减
		/*
		public var fw:Vector3D;//风力
		public var fb:Vector3D;//浮力
		public var fg:Vector3D;//重力
		*/
		public function Particle()
		{
			pos = new Vector3D();
			speed = new Vector3D();
			acc = new Vector3D();
			
			beginColor = new Vector3D();
			endColor = new Vector3D();
		}
		
		/** 添加四个顶点数据 */
		public function copyTo(buffer:Vector.<Number>, index:int):void
		{
			var offset:int = buffer.length;
			
			for(var i:int=0; i<4; i++)//四个顶点
			{
				switch(i){
					case 0:
						buffer[offset++] = -1;
						buffer[offset++] = 1;
						break;
					case 1:
						buffer[offset++] = 1;
						buffer[offset++] = 1;
						break;
					case 2:
						buffer[offset++] = 1;
						buffer[offset++] = -1;
						break;
					case 3:
						buffer[offset++] = -1;
						buffer[offset++] = -1;
						break;
				}
				
				buffer[offset++] = beginSize;
				buffer[offset++] = endSize - beginSize;
				
				//va1 - pos
				buffer[offset++] = pos.x;
				buffer[offset++] = pos.y;
				buffer[offset++] = pos.z;
				buffer[offset++] = startTime;
				
				//va2 - speed
				buffer[offset++] = speed.x;
				buffer[offset++] = speed.y;
				buffer[offset++] = speed.z;
				buffer[offset++] = life;
				
				//va3 - acc
				buffer[offset++] = acc.x;
				buffer[offset++] = acc.y;
				buffer[offset++] = acc.z;
				
				//va4 - beginColor
				buffer[offset++] = beginColor.x;
				buffer[offset++] = beginColor.y;
				buffer[offset++] = beginColor.z;
				buffer[offset++] = beginColor.w;
				
				//va5 - endColor
				buffer[offset++] = endColor.x - beginColor.x;
				buffer[offset++] = endColor.y - beginColor.y;
				buffer[offset++] = endColor.z - beginColor.z;
				buffer[offset++] = endColor.w - beginColor.w;
			}
		}
		//*/
	}
}