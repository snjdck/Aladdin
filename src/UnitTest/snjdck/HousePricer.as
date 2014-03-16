package snjdck
{
	public class HousePricer
	{
		static public const area:Number = 112;
		static public const layer:int = 2;
		
		private var result:Number = 0;
		private var itemCount:int;
		
		public function HousePricer()
		{
			calculate();
			trace("原始总价", result);
			
			var b:Number = 800 * area;
			var c:Number = test(20000, 10);
			var d:Number = test(30000, 10);
			
			trace("门面:", b);
			trace("门面1:", c);
			trace("门面2:", d);
			
			trace("总价:", result+b);
			trace("总价1:", result+c);
			trace("总价2:", result+d);
		}
		
		private function addItem(price:Number, amount:Number, desc:String):void
		{
			var value:Number = price * amount;
			result += value;
			trace(++itemCount, desc, value);
		}
		
		private function calculate():void
		{
			addItem(260, area * layer, "装修");
			addItem(450, area, "架空层(地下室)");
			addItem(600, 98.09, "隔热层(顶层)");
			addItem(200, 17.16, "门口钢棚");
			
			addItem(150, 5, "挂果树");
			addItem(100, 20, "未挂果树");
			addItem(150, 2, "观赏树");
			
			addItem(800, 1, "电表");
			addItem(50, 2, "分电表");
			
			addItem(1500, 1, "水表");
			addItem(50, 2, "分水表");
			
			addItem(300, 1, "有线");
			addItem(300, 2, "电话线");
			addItem(300, 2, "宽带");
			addItem(300, 1, "热水器");
			
			addItem(50, 116.17, "地平");
			addItem(80, 2.16, "后门水泥台阶");
			addItem(35, 3, "巷子围墙");
			addItem(50, 19, "园里铁进水管");
			addItem(20, 19, "园里pvc排水管");
			
			addItem(2000, 1, "搬迁费");
			addItem(800, 24, "临时租房费");
			addItem(800, 24, "临时租房费2");
			addItem(800, 24, "临时租房费3");
			addItem(15000, 1, "土地费");
			addItem(30000, 1, "拆迁奖励");
		}
		
		private function test(val:Number, years:int):Number
		{
			var result:Number = 0;
			for(var i:int=0; i<years; ++i)
			{
				result += val;
				val *= 1.026;
			}
			return result;
		}
	}
}