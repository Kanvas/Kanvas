package landray.kp.maps.main.elements
{
	import model.vo.LineVO;
	
	/**
	 * 双箭头线条
	 */	
	public final class DoubleArrowLine extends ArrowLine
	{
		public function DoubleArrowLine(vo:LineVO)
		{
			super(vo);
		}
		
		/**
		 */		
		override public function render(scale:Number = 1):void
		{
			super.render();
			
			graphics.moveTo( lineVO.width * .5, 0 );
			graphics.lineTo( lineVO.width * .5 - 20, - 15 );
			
			graphics.moveTo( lineVO.width * .5, 0 );
			graphics.lineTo( lineVO.width * .5 - 20,   15 );
			
			graphics.moveTo( 0,   0 );
			graphics.lineTo( 20, -15 );
			
			graphics.moveTo( 0,  0 );
			graphics.lineTo( 20,  15 );
			
		}
	}
}