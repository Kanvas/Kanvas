package landray.kp.maps.main.elements
{
	import model.vo.LineVO;
	
	/**
	 * 单箭头线条
	 */	
	public class ArrowLine extends Line
	{
		public function ArrowLine($vo:LineVO)
		{
			super($vo);
		}
		
		/**
		 */		
		override public function render(scale:Number = 1):void
		{
			super.render();
			
			
			graphics.moveTo(lineVO.width * .5, 0);
			graphics.lineTo(lineVO.width * .5 - 20, - 15);
			
			graphics.moveTo(lineVO.width * .5, 0);
			graphics.lineTo(lineVO.width * .5 - 20, 15);
		}
	}
}