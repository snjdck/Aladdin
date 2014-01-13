/**
	Based on the Public Domain MaxRectanglesBinPack.cpp source by Jukka Jylänki
	https://github.com/juj/RectangleBinPack/
	
	Based on C# port by Sven Magnus 
	http://unifycommunity.com/wiki/index.php?title=MaxRectanglesBinPack
	
	Ported to ActionScript3 by DUZENGQIANG
	http://www.duzengqiang.com/blog/post/971.html
	This version is also public domain - do whatever you want with it.
*/
package snjdck.geom
{
	import flash.geom.Rectangle;

	public class MaxRectsBinPack
	{
		private const usedRects:Vector.<Rectangle> = new Vector.<Rectangle>();
		private const freeRects:Vector.<Rectangle> = new Vector.<Rectangle>();
		
		private var binWidth:int;
		private var binHeight:int;
		
		public function MaxRectsBinPack(width:int, height:int)
		{
			binWidth = width;
			binHeight = height;
			clear();
		}
		
		public function clear():void
		{
			usedRects.length = 0;
			freeRects.length = 0;
			freeRects.push(new Rectangle(0, 0, binWidth, binHeight));
		}
		
		public function getUsedRects():Vector.<Rectangle>
		{
			return usedRects;
		}
		
		private function findBestFreeRect(rectToInsert:Rectangle):Rectangle
		{
			var bestAreaFit:int = int.MAX_VALUE;
			var bestShortSideFit:int;
			var bestFreeRect:Rectangle;
			
			for each(var freeRect:Rectangle in freeRects)
			{
				if(freeRect.width < rectToInsert.width || freeRect.height < rectToInsert.height)
				{
					continue;
				}
				
				var areaFit:int = freeRect.width * freeRect.height - rectToInsert.width * rectToInsert.height;
				var shortSideFit:int = Math.min(freeRect.width-rectToInsert.width, freeRect.height-rectToInsert.height);
				
				if(areaFit < bestAreaFit || (areaFit == bestAreaFit && shortSideFit < bestShortSideFit))
				{
					bestAreaFit = areaFit;
					bestShortSideFit = shortSideFit;
					bestFreeRect = freeRect;
				}
			}
			
			return bestFreeRect;
		}
		
		public function insert(rect:Rectangle):Boolean
		{
			var freeRect:Rectangle = findBestFreeRect(rect);
			
			if(null == freeRect){
				return false;
			}
			
			rect.x = freeRect.x;
			rect.y = freeRect.y;
			
			usedRects.push(rect);
			
			splitFreeNode(rect);
			pruneFreeList(freeRects);
			
			return true;
		}
		
		private function splitFreeNode(usedNode:Rectangle):void
		{
			for(var i:int=freeRects.length-1; i>=0; i--){
				splitFreeNodeImp(freeRects[i], usedNode, i);
			}
		}
		
		private function splitFreeNodeImp(freeNode:Rectangle, usedNode:Rectangle, freeNodeIndex:int):void
		{
			if(
				usedNode.x >= freeNode.right || usedNode.y >= freeNode.bottom ||
				usedNode.right <= freeNode.x || usedNode.bottom <= freeNode.y
			){
				return;
			}
			
			freeRects.splice(freeNodeIndex, 1);
			var newNode:Rectangle;
			
			if(usedNode.y > freeNode.y){// New node at the top side of the used node.
				newNode = freeNode.clone();
				newNode.bottom = usedNode.y;
				freeRects.push(newNode);
			}
			
			if(usedNode.bottom < freeNode.bottom){// New node at the bottom side of the used node.
				newNode = freeNode.clone();
				newNode.y = usedNode.bottom;
				newNode.bottom = freeNode.bottom;
				freeRects.push(newNode);
			}
			
			if(usedNode.x > freeNode.x){// New node at the left side of the used node.
				newNode = freeNode.clone();
				newNode.right = usedNode.x;
				freeRects.push(newNode);
			}
			
			if(usedNode.right < freeNode.right){// New node at the right side of the used node.
				newNode = freeNode.clone();
				newNode.x = usedNode.right;
				newNode.right = freeNode.right;
				freeRects.push(newNode);
			}
		}
	}
}

import flash.geom.Rectangle;

function getMaxRect(rectList:Vector.<Rectangle>):Rectangle
{
	var minX:int = int.MAX_VALUE, maxX:int = 0;
	var minY:int = int.MAX_VALUE, maxY:int = 0;
	
	for each(var rect:Rectangle in rectList)
	{
		if(rect.x < minX)		minX = rect.x;
		if(rect.right > maxX)	maxX = rect.right;
		if(rect.y < minY)		minY = rect.y;
		if(rect.bottom > maxY)	maxY = rect.bottom;
	}
	
	return new Rectangle(minX, minY, maxX-minX, maxY-minY);
}

/** 修剪自由列表 */
function pruneFreeList(rectList:Vector.<Rectangle>):void
{
	for(var i:int=0; i<rectList.length; i++){
		for(var j:int=i+1; j<rectList.length; j++){
			if(isAInsideB(rectList[i], rectList[j])){
				rectList.splice(i--, 1);
				break;
			}else if(isAInsideB(rectList[j], rectList[i])){
				rectList.splice(j--, 1);
			}
		}
	}
}

function isAInsideB(a:Rectangle, b:Rectangle):Boolean
{
	return a.x >= b.x && a.y >= b.y && a.right <= b.right && a.bottom <= b.bottom;
}