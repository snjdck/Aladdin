package snjdck.utils
{
	final public class Color
	{
		/** 16种web标准颜色 */
		static public const BLACK			:uint = 0x000000;//黑色
		static public const GRAY			:uint = 0x808080;//灰色
		static public const SILVER			:uint = 0xC0C0C0;//银色
		static public const WHITE			:uint = 0xFFFFFF;//白色
		
		static public const RED				:uint = 0xFF0000;//红色
		static public const LIME			:uint = 0x00FF00;//酸橙色
		static public const BLUE			:uint = 0x0000FF;//蓝色
		
		static public const MAROON			:uint = 0x800000;//栗色
		static public const GREEN			:uint = 0x008000;//绿色
		static public const NAVY			:uint = 0x000080;//海军蓝
		
		static public const AQUA			:uint = 0x00FFFF;//青色
		static public const FUCHSIA			:uint = 0xFF00FF;//紫红色
		static public const YELLOW			:uint = 0xFFFF00;//黄色
		
		static public const TEAL			:uint = 0x008080;//水鸭色
		static public const PURPLE			:uint = 0x800080;//紫色
		static public const OLIVE			:uint = 0x808000;//橄榄色
		
		static public function GetRed(color:uint):uint
		{
			return (color >>> 16) & 0xFF;
		}
		
		static public function GetGreen(color:uint):uint
		{
			return (color >>> 8) & 0xFF;
		}
		
		static public function GetBlue(color:uint):uint
		{
			return color & 0xFF;
		}
		
		static public function GetAlpha(color:uint):uint
		{
			return (color >>> 24) & 0xFF;
		}
		
		static public function FromRGB(red:uint, green:uint, blue:uint, alpha:uint=0):uint
		{
			return ((alpha & 0xFF) << 24) | ((red & 0xFF) << 16) | ((green & 0xFF) << 8) | (blue & 0xFF);
		}
		
		/**
		 * 计算颜色的灰度值
		 * 快速版:
		 * (red + (green << 1) + blue) >> 2;
		 */
		static public function GetGray(color:uint):int
		{
			return (GetRed(color) * 299 + GetGreen(color) * 587 + GetBlue(color) * 114 + 500) * 0.001;
		}
		
		static public function Difference(colorA:uint, colorB:uint):uint
		{
			return Math.abs(GetRed(colorA)-GetRed(colorB)) + Math.abs(GetGreen(colorA)-GetGreen(colorB)) + Math.abs(GetBlue(colorA)-GetBlue(colorB));
		}
		
		/**
		 * @param color
		 * @return {h, s, b}
		 */
		static public function RGB_2_HSB(color:uint):Object
		{
			var r:uint = GetRed(color);
			var g:uint = GetGreen(color);
			var b:uint = GetBlue(color);
			
			var max:uint = Math.max(r, g, b);
			var min:uint = Math.min(r, g, b);
			
			var result:Object = {h:0, s:0, b:0};
			
			if(max > 0){
				var t:uint = max - min;
				
				result.s = t / max;
				result.b = max / 0xFF;
				
				if(t > 0){
					if(r == max){
						result.h = 60 * (g - b) / t + (g < b ? 360 : 0);
					}else if(g == max){
						result.h = 60 * (b - r) / t + 120;
					}else{
						result.h = 60 * (r - g) / t + 240;
					}
				}
			}
			
			return result;
		}
		
		/**
		 * @param hue 色相
		 * @param saturation 饱和度:(最大值-最小值)/最大值
		 * @param brightness 亮度:最大值/0xFF
		 */		
		static public function HSB_2_RGB(h:Number, s:Number, b:Number):uint
		{
			var t:Number = b * 0xFF;		//t = max, 保证精度
			
			var max:uint = Math.round(t);
			var min:uint = t * (1 - s);
			
			t *= s / 60;	//t = (max - min) / 60
			
			var red:uint;
			var green:uint;
			var blue:uint;
			
			switch(int(h % 360 / 60))
			{
				case 5:{//红色色相
					red = max;
					green = min;
					blue = green - (h - 360) * t;
				}break;
				case 0:{
					red = max;
					blue = min;
					green = blue + h * t;
				}break;
				case 1:{//绿色色相
					green = max;
					blue = min;
					red = blue - (h - 120) * t;
				}break;
				case 2:{
					green = max;
					red = min;
					blue = red + (h - 120) * t;
				}break;
				case 3:{//蓝色色相
					blue = max;
					red = min;
					green = red - (h - 240) * t;
				}break;
				case 4:{
					blue = max;
					green = min;
					red = green + (h - 240) * t;
				}break;
				default:{
					throw new ArgumentError();
				}
			}
			
			return FromRGB(red, green, blue);
		}
		
		/** 其它颜色 */
		static public const PINK			:uint = 0xFFC0CB;//粉红色
		static public const ORANGE			:uint = 0xFFA500;//橙色
		static public const GOLD			:uint = 0xFFD700;//金色
		static public const BROWN			:uint = 0xA52A2A;//褐色
		static public const WOOD			:uint = 0xDEB887;//木色
	}
}