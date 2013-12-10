package view.element.shapes
{
	import model.vo.ElementVO;
	import model.vo.LineVO;
	
	import view.element.ElementBase;
	
	/**
	 * 双箭头线条
	 */	
	public class DoubleArrowLine extends ArrowLine
	{
		public function DoubleArrowLine(vo:ElementVO)
		{
			super(vo);
			
			xmlData = <doubleArrowLine/>
		}
		
		/**
		 */		
		override public function clone():ElementBase
		{
			return new DoubleArrowLine(cloneVO(new LineVO));
		}
		
		/**
		 */		
		override public function render():void
		{
			super.render();
			
			graphics.moveTo(lineVO.width / 2, 0);
			graphics.lineTo(lineVO.width / 2 - 20, - 15);
			
			graphics.moveTo(lineVO.width / 2, 0);
			graphics.lineTo(lineVO.width / 2 - 20, 15);
			
			graphics.moveTo(0, 0);
			graphics.lineTo(20, - 15);
			
			graphics.moveTo(0, 0);
			graphics.lineTo(20, 15);
			
		}
	}
}