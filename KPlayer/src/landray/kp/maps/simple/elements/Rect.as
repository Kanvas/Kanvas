package landray.kp.maps.simple.elements
{
	import com.kvs.utils.XMLConfigKit.StyleManager;
	
	import model.vo.ShapeVO;
	
	public class Rect extends BaseShape
	{
		public function Rect(vo:ShapeVO)
		{
			super(vo);
		}
		override public function render(scale:Number = 1):void
		{
			super.render();
			
			vo.style.radius = rectVO.radius * 2;
			StyleManager.drawRect( this, vo.style, vo );
		}
		protected function get rectVO():ShapeVO
		{
			return vo as ShapeVO;
		}
	}
}