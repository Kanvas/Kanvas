package landray.kp.maps.simple.elements
{	
	import model.vo.ShapeVO;
	
	/**
	 * 图形基类
	 */
	public class BaseShape extends BaseElement
	{
		/**
		 * 
		 */		
		public function BaseShape($vo:ShapeVO)
		{
			super($vo);
		}
		
		protected function get shapeVO():ShapeVO
		{
			return vo as ShapeVO;
		}
	
	}
}