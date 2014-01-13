package snjdck.g3d.asset
{
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DStencilAction;
	import flash.display3D.Context3DTriangleFace;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	import flash.lang.IDisposable;
	
	import snjdck.g3d.core.BlendMode;

	public interface IGpuContext extends IDisposable
	{
		function get driverInfo():String;
		
		function get enableErrorChecking():Boolean;
		function set enableErrorChecking(value:Boolean):void;
		
		function configureBackBuffer(width:int, height:int, antiAlias:int, enableDepthAndStencil:Boolean):void;
		
		function clear(
			red:Number		= 0.0,
			green:Number	= 0.0,
			blue:Number		= 0.0,
			alpha:Number	= 1.0,
			depth:Number	= 1.0,
			stencil:uint	= 0,
			mask:uint		= 0xFFFFFFFF
		):void;
		
		function present():void;
		
		function setColorMask(red:Boolean, green:Boolean, blue:Boolean, alpha:Boolean):void;
		function setCulling(triangleFaceToCull:String):void;
		function setBlendFactor(value:BlendMode):void;
		function setScissorRect(rect:Rectangle):void;
		function setDepthTest(depthMask:Boolean, passCompareMode:String):void;
		
		/** if stencilReference OPERATOR stencilBuffer then pass) */
		function setStencilActions(
			triangleFace:String					= Context3DTriangleFace.FRONT_AND_BACK,
			compareMode:String					= Context3DCompareMode.ALWAYS,
			actionOnBothPass:String				= Context3DStencilAction.KEEP,
			actionOnDepthFail:String			= Context3DStencilAction.KEEP,
			actionOnDepthPassStencilFail:String	= Context3DStencilAction.KEEP
		):void;
		
		function setStencilReferenceValue(refValue:uint, readMask:uint=0xFF, writeMask:uint=0xFF):void;
		
		function setRenderToTexture(texture:IRenderTarget):void;
		function setRenderToBackBuffer():void;
		
		function setVcM(firstRegister:int, matrix:Matrix3D):void;
		function setFcM(firstRegister:int, matrix:Matrix3D):void;
		function setVc(firstRegister:int, data:Vector.<Number>, numRegisters:int=-1):void;
		function setFc(firstRegister:int, data:Vector.<Number>, numRegisters:int=-1):void;
		
		function setProgramConstantsFromVector(programType:String, firstRegister:int, data:Vector.<Number>, numRegisters:int=-1):void;
		
		function setProgram(program:IGpuProgram):void;
		function setVertexBufferAt(slotIndex:int, buffer:IGpuVertexBuffer, bufferOffset:int, format:String):void;
		function setTextureAt(slotIndex:int, texture:IGpuTexture):void;
		function drawTriangles(indexBuffer:IGpuIndexBuffer, firstIndex:int=0, numTriangles:int=-1):void;
	}
}