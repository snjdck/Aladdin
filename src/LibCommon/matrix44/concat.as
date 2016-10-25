package matrix44
{
	internal function concat(va:Vector.<Number>, vb:Vector.<Number>, output:Vector.<Number>):void
	{
		output[0 ] = (va[0 ] * vb[0]) + (va[1 ] * vb[4]) + (va[2 ] * vb[8 ]);
		output[4 ] = (va[4 ] * vb[0]) + (va[5 ] * vb[4]) + (va[6 ] * vb[8 ]);
		output[8 ] = (va[8 ] * vb[0]) + (va[9 ] * vb[4]) + (va[10] * vb[8 ]);
		output[12] = (va[12] * vb[0]) + (va[13] * vb[4]) + (va[14] * vb[8 ]) + vb[12];
		
		output[1 ] = (va[0 ] * vb[1]) + (va[1 ] * vb[5]) + (va[2 ] * vb[9 ]);
		output[5 ] = (va[4 ] * vb[1]) + (va[5 ] * vb[5]) + (va[6 ] * vb[9 ]);
		output[9 ] = (va[8 ] * vb[1]) + (va[9 ] * vb[5]) + (va[10] * vb[9 ]);
		output[13] = (va[12] * vb[1]) + (va[13] * vb[5]) + (va[14] * vb[9 ]) + vb[13];
		
		output[2 ] = (va[0 ] * vb[2]) + (va[1 ] * vb[6]) + (va[2 ] * vb[10]);
		output[6 ] = (va[4 ] * vb[2]) + (va[5 ] * vb[6]) + (va[6 ] * vb[10]);
		output[10] = (va[8 ] * vb[2]) + (va[9 ] * vb[6]) + (va[10] * vb[10]);
		output[14] = (va[12] * vb[2]) + (va[13] * vb[6]) + (va[14] * vb[10]) + vb[14];
		
		output[3 ] = (va[0 ] * vb[3]) + (va[1 ] * vb[7]) + (va[2 ] * vb[11]);
		output[7 ] = (va[4 ] * vb[3]) + (va[5 ] * vb[7]) + (va[6 ] * vb[11]);
		output[11] = (va[8 ] * vb[3]) + (va[9 ] * vb[7]) + (va[10] * vb[11]);
		output[15] = (va[12] * vb[3]) + (va[13] * vb[7]) + (va[14] * vb[11]) + vb[15];
	}
}