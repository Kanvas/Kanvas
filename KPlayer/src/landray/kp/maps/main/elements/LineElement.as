package landray.kp.maps.main.elements
{
	import com.kvs.utils.XMLConfigKit.StyleManager;
	
	import flash.geom.Rectangle;
	
	import model.vo.LineVO;
	
	/**
	 * 线条
	 */	
	public class LineElement extends BaseElement
	{
		public function LineElement($vo:LineVO)
		{
			super($vo);
		}
		
		/**
		 */		
		override public function render(scale:Number = 1):void
		{
			super.render();
			
			StyleManager.setLineStyle( graphics, lineVO.style.getBorder, lineVO.style, vo );
			graphics.moveTo( 0, 0 );
			graphics.lineTo( lineVO.width * .5, 0 );
		}
		override public function getRectangleForViewer():Rectangle
		{
			var rect:Rectangle = super.getRectangleForViewer();
			rect.x += vo.width  * .5;
			rect.y += vo.height * .5;
			rect.width  *= .5;
			rect.height *= .5;
			return rect;
		}
		/**
		 */		
		protected function get lineVO():LineVO
		{
			return vo as LineVO;
		}
		
	}
}