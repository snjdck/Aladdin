package Box2D.Dynamics
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	import Box2D.Common.b2Color;
	import Box2D.Common.b2internal;
	import Box2D.Common.Math.b2Transform;
	import Box2D.Common.Math.b2Vec2;
	
	use namespace b2internal;
	
	/**
	* Implement and register this class with a b2World to provide debug drawing of physics
	* entities in your game.
	*/
	public class b2DebugDraw
	{
		/** Draw shapes */
		static public const e_shapeBit			:uint = 0x0001;
		/** Draw joint connections */
		static public const e_jointBit			:uint = 0x0002;
		/** Draw axis aligned bounding boxes */
		static public const e_aabbBit			:uint = 0x0004;
		/** Draw broad-phase pairs */
		static public const e_pairBit			:uint = 0x0008;
		/** Draw center of mass frame */
		static public const e_centerOfMassBit	:uint = 0x0010;
		/** Draw controllers */
		static public const e_controllerBit		:uint = 0x0020;
	
		public function b2DebugDraw()
		{
			m_drawFlags = 0;
		}
	
		/**
		* Set the drawing flags.
		*/
		public function SetFlags(flags:uint):void
		{
			m_drawFlags = flags;
		}
	
		/**
		* Get the drawing flags.
		*/
		public function GetFlags():uint
		{
			return m_drawFlags;
		}
		
		/**
		* Append flags to the current flags.
		*/
		public function AppendFlags(flags:uint):void
		{
			m_drawFlags |= flags;
		}
	
		/**
		* Clear flags from the current flags.
		*/
		public function ClearFlags(flags:uint):void
		{
			m_drawFlags &= ~flags;
		}
		
		/**
		* Set the draw scale
		*/
		public function SetDrawScale(drawScale:Number) : void {
			m_drawScale = drawScale; 
		}
		
		/**
		* Get the draw
		*/
		public function GetDrawScale() : Number {
			return m_drawScale;
		}
		
		/**
		* Set the line thickness
		*/
		public function SetLineThickness(lineThickness:Number) : void {
			m_lineThickness = lineThickness; 
		}
		
		/**
		* Get the line thickness
		*/
		public function GetLineThickness() : Number {
			return m_lineThickness;
		}
		
		/**
		* Set the alpha value used for lines
		*/
		public function SetAlpha(alpha:Number) : void {
			m_alpha = alpha; 
		}
		
		/**
		* Get the alpha value used for lines
		*/
		public function GetAlpha() : Number {
			return m_alpha;
		}
		
		/**
		* Set the alpha value used for fills
		*/
		public function SetFillAlpha(alpha:Number) : void {
			m_fillAlpha = alpha; 
		}
		
		/**
		* Get the alpha value used for fills
		*/
		public function GetFillAlpha() : Number {
			return m_fillAlpha;
		}
		
		/**
		* Set the scale used for drawing XForms
		*/
		public function SetXFormScale(xformScale:Number) : void {
			m_xformScale = xformScale; 
		}
		
		/**
		* Get the scale used for drawing XForms
		*/
		public function GetXFormScale() : Number {
			return m_xformScale;
		}
		
		/**
		* Draw a closed polygon provided in CCW order.
		*/
		public function DrawPolygon(vertices:Array, vertexCount:int, color:b2Color) : void
		{
			var g:Graphics = m_sprite.graphics;
			
			g.lineStyle(m_lineThickness, color.color, m_alpha);
			g.moveTo(vertices[0].x * m_drawScale, vertices[0].y * m_drawScale);
			for (var i:int = 1; i < vertexCount; i++){
					g.lineTo(vertices[i].x * m_drawScale, vertices[i].y * m_drawScale);
			}
			g.lineTo(vertices[0].x * m_drawScale, vertices[0].y * m_drawScale);
			
		}
	
		/**
		* Draw a solid closed polygon provided in CCW order.
		*/
		public function DrawSolidPolygon(vertices:Vector.<b2Vec2>, vertexCount:int, color:b2Color) : void
		{
			var g:Graphics = m_sprite.graphics;
			
			g.lineStyle(m_lineThickness, color.color, m_alpha);
			g.moveTo(vertices[0].x * m_drawScale, vertices[0].y * m_drawScale);
			g.beginFill(color.color, m_fillAlpha);
			for (var i:int = 1; i < vertexCount; i++){
					g.lineTo(vertices[i].x * m_drawScale, vertices[i].y * m_drawScale);
			}
			g.lineTo(vertices[0].x * m_drawScale, vertices[0].y * m_drawScale);
			g.endFill();
			
		}
	
		/**
		* Draw a circle.
		*/
		public function DrawCircle(center:b2Vec2, radius:Number, color:b2Color) : void
		{
			var g:Graphics = m_sprite.graphics;
			
			g.lineStyle(m_lineThickness, color.color, m_alpha);
			g.drawCircle(center.x * m_drawScale, center.y * m_drawScale, radius * m_drawScale);
			
		}
		
		/**
		* Draw a solid circle.
		*/
		public function DrawSolidCircle(center:b2Vec2, radius:Number, axis:b2Vec2, color:b2Color):void
		{
			var g:Graphics = m_sprite.graphics;
			
			g.lineStyle(m_lineThickness, color.color, m_alpha);
			g.moveTo(0,0);
			g.beginFill(color.color, m_fillAlpha);
			g.drawCircle(center.x * m_drawScale, center.y * m_drawScale, radius * m_drawScale);
			g.endFill();
			g.moveTo(center.x * m_drawScale, center.y * m_drawScale);
			g.lineTo((center.x + axis.x*radius) * m_drawScale, (center.y + axis.y*radius) * m_drawScale);
		}
	
		
		/**
		* Draw a line segment.
		*/
		public function DrawSegment(p1:b2Vec2, p2:b2Vec2, color:b2Color):void
		{
			var g:Graphics = m_sprite.graphics;
			
			g.lineStyle(m_lineThickness, color.color, m_alpha);
			g.moveTo(p1.x * m_drawScale, p1.y * m_drawScale);
			g.lineTo(p2.x * m_drawScale, p2.y * m_drawScale);
		}
	
		/**
		* Draw a transform. Choose your own length scale.
		* @param xf a transform.
		*/
		public function DrawTransform(xf:b2Transform):void
		{
			var g:Graphics = m_sprite.graphics;
			
			g.lineStyle(m_lineThickness, 0xff0000, m_alpha);
			g.moveTo(xf.position.x * m_drawScale, xf.position.y * m_drawScale);
			g.lineTo((xf.position.x + m_xformScale*xf.R.col1.x) * m_drawScale, (xf.position.y + m_xformScale*xf.R.col1.y) * m_drawScale);
			
			g.lineStyle(m_lineThickness, 0x00ff00, m_alpha);
			g.moveTo(xf.position.x * m_drawScale, xf.position.y * m_drawScale);
			g.lineTo((xf.position.x + m_xformScale*xf.R.col2.x) * m_drawScale, (xf.position.y + m_xformScale*xf.R.col2.y) * m_drawScale);
		}
		
		public function SetSprite(value:Sprite):void
		{
			this.m_sprite = value;
		}
		
		private var m_drawFlags:uint;
		public var m_sprite:Sprite;
		private var m_drawScale:Number = 1.0;
		
		private var m_lineThickness:Number = 1.0;
		private var m_alpha:Number = 1.0;
		private var m_fillAlpha:Number = 1.0;
		private var m_xformScale:Number = 1.0;
	}
}