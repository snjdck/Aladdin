package snjdck.agalc
{
	final internal class RegisterType
	{
		static public const Attribute		:uint = 0x0;	//va
		static public const Constant		:uint = 0x1;	//vc, fc
		static public const Temporary		:uint = 0x2;	//vt, ft
		static public const Output			:uint = 0x3;	//op, oc
		static public const Varying			:uint = 0x4;	//v
		static public const Sampler			:uint = 0x5;	//fs
		static public const DepthOutput		:uint = 0x6;	//fd
	}
}