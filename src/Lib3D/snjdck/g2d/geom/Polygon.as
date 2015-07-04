package snjdck.g2d.geom
{
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.geom.d2.JudgePtToTriangle;

	public class Polygon
	{
		private var vertexList:Vector.<Number>;
		
		public function Polygon()
		{
			vertexList = new Vector.<Number>();
		}
		
		public function get vertexCount():int
		{
			return vertexList.length >> 1;
		}
		
		public function addVertex(px:Number, py:Number):void
		{
			vertexList.push(px, py);
		}
		
		public function setVertex(index:int, px:Number, py:Number):void
		{
			var offset:int = index << 1;
			vertexList[offset  ] = px;
			vertexList[offset+1] = py;
		}
		
		public function getVertex(index:int, result:Point):void
		{
			var offset:int = index << 1;
			result.x = vertexList[offset];
			result.y = vertexList[offset+1];
		}
		
		/** http://alienryderflex.com/polygon/ */
		public function contains(px:Number, py:Number):Boolean
		{
			var count:int = vertexList.length;
			
			if(count < 6){//三角形
				return false;
			}
			
			var bx:Number = vertexList[count-2];
			var by:Number = vertexList[count-1];
			
			var result:Boolean = false;
			
			for(var i:int=0; i<count; i+=2)
			{
				var ax:Number = vertexList[i];
				var ay:Number = vertexList[i+1];
				
				if((ay < py && by >= py || by < py && ay >= py) && (ax <= px || bx <= px)){
					var hitX:Number = (py - ay) / (by - ay) * (bx - ax) + ax;
					if(hitX < px){
						result = !result;
					}
				}
				
				bx = ax;
				by = ay;
			}
			
			return result;
		}
		
		public function triangulate():Vector.<uint>
		{
			var count:int = vertexList.length >> 1;
			
			var result:Vector.<uint> = new Vector.<uint>();
			var tempList:Vector.<uint> = new Vector.<uint>();
			
			for (var i:int = 0; i < count; i++){
				tempList[i] = i;
			}
			
			var fromIndex:int = 0;
			while(tempList.length > 3 && fromIndex < tempList.length)
			{
				var index0:uint = getValue(tempList, fromIndex);
				var index1:uint = getValue(tempList, fromIndex+1);
				var index2:uint = getValue(tempList, fromIndex+2);
				
				getVertex(index0, pa);
				getVertex(index1, pb);
				getVertex(index2, pc);
				
				var earFound:Boolean = false;
				if(isTriangleConvex(pa.x, pa.y, pb.x, pb.y, pc.x, pc.y)){
					earFound = true;
					for(i=3; i<tempList.length; ++i){
						getVertex(getValue(tempList, fromIndex+i), pd);
						if(JudgePtToTriangle.Judge(pd, pa, pb, pc) < 0){
							earFound = false;
							break;
						}
					}
				}
				if(earFound){
					result.push(index0, index1, index2);
					fromIndex = (fromIndex + 1) % tempList.length;
					tempList.splice(fromIndex, 1);
					fromIndex = 0;
				}else{
					++fromIndex;
				}
			}
			
			result.push(tempList[0]);
			result.push(tempList[1]);
			result.push(tempList[2]);
			
			return result;
		}
		
		public function drawGraphics(g:Graphics):void
		{
			var count:int = vertexList.length;
			g.moveTo(vertexList[0], vertexList[1]);
			for(var i:int=2; i<count; i+=2){
				g.lineTo(vertexList[i], vertexList[i+1]);
			}
			g.lineTo(vertexList[0], vertexList[1]);
		}
		
		public function drawIndices(g:Graphics, indices:Vector.<uint>):void
		{
			for(var i:int=0; i<indices.length; i+=3)
			{
				getVertex(indices[i  ], pa);
				getVertex(indices[i+1], pb);
				getVertex(indices[i+2], pc);
				
				g.moveTo(pa.x, pa.y);
				g.lineTo(pb.x, pb.y);
				g.lineTo(pc.x, pc.y);
				g.lineTo(pa.x, pa.y);
			}
		}
		
		static private const pa:Point = new Point();
		static private const pb:Point = new Point();
		static private const pc:Point = new Point();
		static private const pd:Point = new Point();
		
		static private function getValue(list:Vector.<uint>, index:int):uint
		{
			return list[index % list.length];
		}
		
		static public function isTriangleConvex(
			ax:Number, ay:Number,
			bx:Number, by:Number,
			cx:Number, cy:Number
		):Boolean
		{
			return (bx - ax) * (cy - by) - (by - ay) * (cx - bx) >= 0;
		}
	}
}