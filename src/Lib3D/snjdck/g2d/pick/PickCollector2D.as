package snjdck.g2d.pick
{
	import snjdck.g2d.ns_g2d;
	import snjdck.g2d.impl.Collector2D;
	import snjdck.g2d.render.DrawUnit2D;
	
	use namespace ns_g2d;

	public class PickCollector2D extends Collector2D
	{
		public function PickCollector2D()
		{
		}
		
		public function getFirstDrawUnit():DrawUnit2D
		{
			return quadList.length > 0 ? quadList[0] : null;
		}
	}
}