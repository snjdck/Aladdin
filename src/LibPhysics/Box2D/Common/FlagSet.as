package Box2D.Common
{
	final public class FlagSet
	{
		private var m_flags:uint;
		
		public function FlagSet()
		{
		}
		
		[Inline]
		final public function addFlag(flag:uint):void
		{
			m_flags |= flag;
		}
		
		[Inline]
		final public function clearFlag(flag:uint):void
		{
			m_flags &= ~flag;
		}
		
		[Inline]
		final public function clearAllFlags():void
		{
			m_flags = 0;
		}
		
		[Inline]
		final public function hasFlagAny(flag:uint):Boolean
		{
			return (m_flags & flag) != 0;
		}
		
		[Inline]
		final public function hasFlagAll(flag:uint):Boolean
		{
			return (m_flags & flag) == flag;
		}
	}
}