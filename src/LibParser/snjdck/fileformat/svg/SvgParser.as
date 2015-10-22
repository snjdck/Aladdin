package snjdck.fileformat.svg
{
	import flash.debugger.enterDebugger;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	import flash.display.GraphicsPathWinding;
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;

	public class SvgParser
	{
		public function SvgParser()
		{
		}
		
		public function parseSvg(xml:XML):Sprite
		{
			var result:Sprite = new Sprite();
			for each(var node:XML in xml.children()){
				result.addChild(parse(node));
			}
			return result;
		}
		
		private function parse(node:XML):DisplayObject
		{
			var result:DisplayObject;
			switch(node.localName())
			{
				case "g":
					result = parseSvg(node);
					break;
				case "path":
					result = parsePath(node);
					break;
				case "line":
					result = new Shape();
					//<line fill="none" stroke="#000000" stroke-width="0.5616" stroke-linecap="round" stroke-linejoin="round" x1="106.698" y1="97.795" x2="106.688" y2="97.795" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"/>
					break;
				case "polyline":
					result = new Shape();
					//<polyline fill="none" stroke="#000000" stroke-width="0.5616" stroke-linecap="round" stroke-linejoin="round" points="&#xD;&#xA;&#x9;&#x9;&#x9;113.497,93.769 101.921,65.941 101.123,64.027 97.985,56.487 95.793,51.218 92.043,42.199 &#x9;&#x9;" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"/>
					break;
				case "polygon"://要闭合到第一个点
					result = new Shape();
					//<polygon fill="#FBB040" points="72.752,46.056 43.383,71.458 53.458,71.458 53.458,95.394 67.188,95.394 67.188,78.797 &#xD;&#xA;&#x9;&#x9;78.314,78.797 78.314,95.394 92.045,95.394 92.045,71.458 102.12,71.458 &#x9;" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"/>
					break;
				case "circle":
					result = parseCircle(node);
					break;
				case "ellipse":
					result = parseEllipse(node);
					break;
				default:
					result = new Shape();
					trace(node.toXMLString());
					enterDebugger();
					break;
			}
			result.name = node.@id.toString();
			setTransform(node, result);
			return result;
		}
		
		private function parsePath(node:XML):Shape
		{
			var result:Shape = createShape(node);
			parseData(result.graphics, node.@d.toString());
			return result;
		}
		
		private function parseData(g:Graphics, data:String):void
		{
			var cmdOp:Vector.<int> = new Vector.<int>();
			var cmdData:Vector.<Number> = new Vector.<Number>();
			
			var list:Array = splitCmd(data);
			while(list.length > 0){
				var op:String = list.shift();
				switch(op.toUpperCase())
				{
					case "M":
						cmdOp.push(GraphicsPathCommand.MOVE_TO);
						cmdData.push(parseFloat(list.shift()));
						cmdData.push(parseFloat(list.shift()));
						break;
					case "C":
						cmdOp.push(GraphicsPathCommand.CUBIC_CURVE_TO);
						cmdData.push(parseFloat(list.shift()));
						cmdData.push(parseFloat(list.shift()));
						cmdData.push(parseFloat(list.shift()));
						cmdData.push(parseFloat(list.shift()));
						cmdData.push(parseFloat(list.shift()));
						cmdData.push(parseFloat(list.shift()));
						break;
					case "L":
						cmdOp.push(GraphicsPathCommand.LINE_TO);
						cmdData.push(parseFloat(list.shift()));
						cmdData.push(parseFloat(list.shift()));
						break;
					case "V":
						list.shift();
						break;
					case "H":
						list.shift();
						break;
					case "S":
						list.shift();
						list.shift();
						list.shift();
						list.shift();
						break;
					case "Z":
						break;
					default:
						if(Boolean(op)){
							trace("===========", op);
							enterDebugger();
						}
				}
			}
			g.drawPath(cmdOp, cmdData, GraphicsPathWinding.EVEN_ODD);
		}
		
		private function setFill(node:XML, g:Graphics):Boolean
		{
			var info:String = node.@fill.toString();
			if(!Boolean(info)){
				return false;
			}
			if(info != "none"){
				g.beginFill(parseInt(info.slice(1), 16));
			}
			return true;
		}
		
		private function setStroke(node:XML, g:Graphics):Boolean
		{
			var info:String = node.@stroke.toString();
			if(!Boolean(info)){
				return false;
			}
			g.lineStyle(
				parseFloat(node.attribute("stroke-width")),
				parseInt(info.slice(1), 16),
				1,false,LineScaleMode.NORMAL,
				node.attribute("stroke-linecap"),
				node.attribute("stroke-linejoin")
			);
			return true;
		}
		
		private function setTransform(node:XML, target:DisplayObject):void
		{
			var info:String = node.@transform.toString();
			if(!Boolean(info)){
				return;
			}
			var list:Array = info.slice(7, -1).split(", ");
			target.transform.matrix = new Matrix(
				parseFloat(list[0]),
				parseFloat(list[1]),
				parseFloat(list[2]),
				parseFloat(list[3]),
				parseFloat(list[4]),
				parseFloat(list[5])
			);
		}
		
		private function splitCmd(data:String):Array
		{
			data = data.replace(/([a-zA-Z])(\d)/g, "$1,$2");
			data = data.replace(/(\d)([a-zA-Z])/g, "$1,$2");
			data = data.replace(/(\w)-(?=\w)/g, "$1,");
			data = data.replace(/\s+/g, ",");
			return data.split(",");
		}
		
		private function parseCircle(node:XML):Shape
		{
			var result:Shape = createShape(node);
			result.graphics.drawCircle(
				parseFloat(node.@cx),
				parseFloat(node.@cy),
				parseFloat(node.@r)
			);
			return result;
		}
		
		private function parseEllipse(node:XML):Shape
		{
			var result:Shape = createShape(node);
			result.graphics.drawEllipse(
				parseFloat(node.@cx),
				parseFloat(node.@cy),
				parseFloat(node.@rx),
				parseFloat(node.@ry)
			);
			return result;
		}
		
		private function createShape(node:XML):Shape
		{
			var result:Shape = new Shape();
			var g:Graphics = result.graphics;
			var isStrokeSet:Boolean = setStroke(node, g);
			var isFillSet:Boolean = setFill(node, g);
			if(!(isStrokeSet || isFillSet)){
				g.beginFill(0);
			}
			return result;
		}
	}
}