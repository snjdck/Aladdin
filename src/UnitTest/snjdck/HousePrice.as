package snjdck
{
	public class HousePrice
	{
		public var yearRate:Number = 0.05;
		public var numYear:int = 30;
		public var firstPayRate:Number = 0.3;
		
		private var daikuan:int;
		
		private var list1:Array = [];
		private var list2:Array = [];
		
		public function HousePrice(price:int, area:int)
		{
			var totalPrice:int = price * area;
			daikuan = totalPrice * (1 - firstPayRate);
			trace("total:", totalPrice * 0.0001 + "w");
			trace("first pay:", totalPrice * firstPayRate * 0.0001 + "w");
			trace("dai kuan:", daikuan * 0.0001 + "w");
			var t0:Number = test1(list1);
			var t1:Number = test2(list2);
			trace(t0, t1);
			trace(t0 / daikuan, t1 / daikuan);
			for(var i:int=0; i<numMonth; ++i){
//				trace(int(i/12+1) + "-" + (i%12+1), "\t", Math.round(list1[i]), "\t", Math.round(list2[i]));
				trace(int(i/12+1) + "-" + (i%12+1), "\t", getSingleMonthCostPercent1(i), "\t", getSingleMonthCostPercent2());
			}
			for(i=1; i<10; ++i){
				printCost(12*i);
			}
			trace(daikuan * getTotalExtraMoney1());
			trace(daikuan * getTotalExtraMoney2());
//			trace(calcMonthIndexWhenEqual());
		}
		
		public function get monthRate():Number
		{
			return yearRate / 12;
		}
		
		public function get numMonth():int
		{
			return numYear * 12;
		}
		
		private function test1(result:Array):Number
		{
			var monthBase:int = daikuan / numMonth;
			var paidMoney:Number = 0;
			var extraMoney:Number = 0;
			for(var i:int=0; i<numMonth; ++i){
				var value:Number = (daikuan - paidMoney) * monthRate;
				paidMoney += monthBase;
				extraMoney += value;
//				result.push(monthBase + value);
				result.push(getSingleMonthCost1(i));
			}
			return extraMoney;
		}
		
		private function test2(result:Array):Number
		{
			var monthBase:Number = daikuan * monthRate / (Math.pow(1 + monthRate, numMonth) - 1);
			var paidMoney:Number = 0;
			var extraMoney:Number = 0;
			for(var i:int=0; i<numMonth; ++i){
				var value:Number = (daikuan - paidMoney) * monthRate;
				extraMoney += value;
				paidMoney += monthBase;
				result.push(monthBase + value);
				monthBase *= 1 + monthRate;
			}
			return extraMoney;
		}
		
		private function getTotalExtraMoney1():Number
		{
			return 0.5 * monthRate * (numMonth + 1);
		}
		
		private function getTotalExtraMoney2():Number
		{
			return getTotalCost2(numMonth) - 1;
		}

		private function getTotalCost1(monthCount:int):Number
		{
			return 0.5 * monthCount * (getSingleMonthCost1(0) + getSingleMonthCost1(monthCount-1));
		}
		
		private function getTotalCost2(monthCount:int):Number
		{
			return getSingleMonthCost2() * monthCount;
		}
		
		private function getSingleMonthCost1(monthIndex:int):Number
		{
			return monthRate * getSingleMonthCostPercent1(monthIndex);
		}
		
		private function getSingleMonthCost2():Number
		{
			return monthRate * getSingleMonthCostPercent2();
		}
		
		private function getSingleMonthCostPercent1(monthIndex:int):Number
		{
			return 1 / (yearRate * numYear) - monthIndex / numMonth + 1;
		}
		
		private function getSingleMonthCostPercent2():Number
		{
			return 1 / (Math.pow(1 + monthRate, numMonth) - 1) + 1;
		}
		
		private function printCost(monthCount:int):void
		{
			var cost:Number = getTotalCost2(monthCount);
			trace("hold " + (monthCount / 12) + " year:", cost * (1 - firstPayRate) / firstPayRate, cost * (1 - firstPayRate));
		}
	}
}