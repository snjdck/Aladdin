package flash.utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	final public class DisplayUtil
	{
		static public function InitStage(stage:Stage):void
		{
			stage.align = StageAlign.TOP_LEFT;		//默认值为""(空字符串)
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.HIGH;
			stage.showDefaultContextMenu = false;
			stage.stageFocusRect = false;
		}
		
		static public function MoveTo(target:DisplayObject, tx:Number, ty:Number=0):void
		{
			target.x = tx;
			target.y = ty;
		}
		
		static public function SizeTo(target:DisplayObject, tw:Number, th:Number):void
		{
			target.width = tw;
			target.height = th;
		}
		
		static public function ScaleTo(target:DisplayObject, scaleX:Number, scaleY:Number=NaN):void
		{
			target.scaleX = scaleX;
			target.scaleY = isNaN(scaleY) ? scaleX : scaleY;
		}
		
		static public function Traverse(target:DisplayObject, handler:Function):void
		{
			handler(target);
			var container:DisplayObjectContainer = target as DisplayObjectContainer;
			if(null == container){
				return;
			}
			for(var i:int=0, n:int=container.numChildren; i<n; ++i){
				Traverse(container.getChildAt(i), handler);
			}
		}
		
		static public function AddChild(parent:DisplayObjectContainer, child:DisplayObject, px:Number=0, py:Number=0, index:int=-1):void
		{
			MoveTo(child, px, py);
			
			if(index >= 0){
				parent.addChildAt(child, index);
			}else{
				parent.addChild(child);
			}
		}
		
		static public function AddChildren(parent:DisplayObjectContainer, args:Array):void
		{
			if(null == args || args.length < 1){
				return;
			}
			for each(var child:DisplayObject in args){
				parent.addChild(child);
			}
		}
		
		static public function GetChildren(parent:DisplayObjectContainer, fromIndex:int=0, toIndex:int=-1):Array
		{
			if(toIndex < 0){
				toIndex = parent.numChildren;
			}
			
			var children:Array = [];
			while(fromIndex < toIndex){
				children[children.length] = parent.getChildAt(fromIndex++);
			}
			return children;
		}
		
		static public function RemoveTopChild(parent:DisplayObjectContainer):DisplayObject
		{
			return parent.removeChildAt(parent.numChildren-1);
		}
		
		static public function RemoveSelf(target:DisplayObject):void
		{
			if(target && target.parent){
				target.parent.removeChild(target);
			}
		}
		
		static public function DragSpriteInBound(target:Sprite, bound:Rectangle):void
		{
			var rect:Rectangle = target.getRect(target.parent);
			
			target.startDrag(false, new Rectangle(
				target.x - (rect.right - bound.width),
				target.y - (rect.bottom - bound.height),
				target.width - bound.width,
				target.height - bound.height
			));
		}
		
		/**
		 * @param pts Array(or Vector) of objects(which contains x and y property,like Point)
		 */
		public function MoveWithPath(target:DisplayObject, speed:Number, pts:Object, callback:Object, fromIndex:int=0):void
		{
			if(fromIndex >= pts.length){
				$lambda.apply(callback);
				return;
			}
			
			const pt:Object = pts[fromIndex];
			
			const dx:Number = pt.x - target.x;
			const dy:Number = pt.y - target.y;
			const angle:Number = Math.atan2(dy, dx);
			const speedX:Number = speed * Math.cos(angle);
			const speedY:Number = speed * Math.sin(angle);
			
			const totalStep:int = Math.ceil(Math.sqrt(dx*dx+dy*dy)/speed);
			var step:int = 0;
			
			target.rotation = angle * 180 / Math.PI;
			target.addEventListener(Event.ENTER_FRAME, function(evt:Event):void
			{
				if(++step >= totalStep){
					target.x = pt.x;
					target.y = pt.y;
					target.removeEventListener(evt.type, arguments.callee);
					MoveWithPath(target, speed, pts, callback, fromIndex+1);
				}else{
					target.x += speedX;
					target.y += speedY;
				}
			});
		}
		
		/**
		 * @see display_lookAtPosition
		 */	
		static public function LookAtObject(target:DisplayObject, object:Object, initRotation:Number=0):void
		{
			LookAtPosition(target, object.x, object.y, initRotation);
		}
		
		/**
		 * 从 0 到 180 的值表示顺时针方向旋转；从 0 到 -180 的值表示逆时针方向旋转。 以度为单位。
		 */
		static public function LookAtPosition(target:DisplayObject, posX:Number, posY:Number, initRotation:Number=0):void
		{
			var dx:Number = posX - target.x;
			var dy:Number = posY - target.y;
			target.rotation = Math.atan2(dy, dx) * (180 / Math.PI) - initRotation;
		}
		
		static public function Zoom(target:DisplayObject, zoom:Number, lockArea:Boolean=false):void
		{
			const offsetX:Number = target.parent.mouseX;
			const offsetY:Number = target.parent.mouseY;
			
			const multi:Number = zoom / target.scaleX;
			
			matrix.identity();
			matrix.translate(-offsetX, -offsetY);
			matrix.scale(multi, multi);
			matrix.translate(offsetX, offsetY);
			
			const prevMatrix:Matrix = target.transform.matrix;
			prevMatrix.concat(matrix);
			target.transform.matrix = prevMatrix;
			
			if(!lockArea){
				return;
			}
			
			if(target.x > 0){
				target.x = 0;
			}
			
			if(target.y > 0){
				target.y = 0;
			}
			
			if(target.x + target.width < target.stage.stageWidth){
				target.x = target.stage.stageWidth - target.width;
			}
			
			if(target.y + target.height < target.stage.stageHeight){
				target.y = target.stage.stageHeight - target.height;
			}
		}
		
		static private const matrix:Matrix = new Matrix();
	}
}