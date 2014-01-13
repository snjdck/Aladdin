package snjdck.game.common.utils
{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	
	/**
	 * 关于碰撞检测://http://uh.actionscript3.cn/space.php?uid=3641&do=blog&id=2743
		1.hitTestObject与hitTestPoint
		2.基于距离,2点之间的距离是否大于其半径之和
		3.BitmapData.hitTest()
		4.Rectangle.intersects()
		5.BitmapData.getColorBoundsRect().isEmpty()
		6.多物体,遍历或者基于网格检测碰撞
		
		1. 找出两个对象边界矩形的交叉区域，若没有则没有发生碰撞
		2. 创建一个与交叉区域同样大小的bitmap
		3. 将第一个对象相交的部分以红色绘制在bitmap中
		4. 将第二个对象的相交部分以白色绘制在bitmap中，BlendMode（混合模式）为DIFFERENCE。
		5. 找出颜色为cyan的区域并返回其边界矩形。若没有则说明没有发生碰撞
	 * @author SK
	 * 
	 */	
	public class Collision
	{
		static private const ctf_red	:ColorTransform = new ColorTransform(0, 0, 0, 0, 255, 0, 0, 255);
		static private const ctf_aqua	:ColorTransform = new ColorTransform(0, 0, 0, 0, 0, 255, 255, 255);
		
		static public function HitTest(dock:BitmapData, targetA:DisplayObject, targetB:DisplayObject):Boolean
		{
			if(targetA.hitTestObject(targetB))
			{
				dock.fillRect(dock.rect, 0);
				dock.draw(targetA, targetA.transform.matrix, ctf_red);
				dock.draw(targetB, targetB.transform.matrix, ctf_aqua, BlendMode.DIFFERENCE);
				return !dock.getColorBoundsRect(0xFFFFFFFF, 0xFFFFFFFF).isEmpty();
			}
			return false;
		}
	}
}