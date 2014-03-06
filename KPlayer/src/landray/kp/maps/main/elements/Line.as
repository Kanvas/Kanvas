package landray.kp.maps.main.elements
{
	import com.kvs.utils.XMLConfigKit.StyleManager;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import model.vo.LineVO;
	
	/**
	 * 线条
	 */	
	public class Line extends Element
	{
		public function Line($vo:LineVO)
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
		
		override public function get topLeft():Point
		{
			tlPoint.x = 0;
			tlPoint.y = - .5 * vo.scale * vo.height;
			return caculateTransform(tlPoint);
		}
		
		override public function get topCenter():Point
		{
			tcPoint.x =   .25 * vo.scale * vo.width;
			tcPoint.y = - .5  * vo.scale * vo.height;
			return caculateTransform(tcPoint);
		}
		
		override public function get middleLeft():Point
		{
			mlPoint.x = x;
			mlPoint.y = y;
			return mlPoint;
		}
		
		override public function get middleCenter():Point
		{
			mcPoint.x = .25 * vo.scale * vo.width;
			mcPoint.y = 0;
			return caculateTransform(mcPoint);
		}
		
		override public function get bottomLeft():Point
		{
			blPoint.x = 0;
			blPoint.y = .5 * vo.scale * vo.height;
			return caculateTransform(blPoint);
		}
		
		override public function get bottomCenter():Point
		{
			bcPoint.x = .25 * vo.scale * vo.width;;
			bcPoint.y = .5  * vo.scale * vo.height;
			return caculateTransform(bcPoint);
		}
		
		override public function get left():Number
		{
			return x;
		}
		
		/**
		 */		
		protected function get lineVO():LineVO
		{
			return vo as LineVO;
		}
		
	}
}