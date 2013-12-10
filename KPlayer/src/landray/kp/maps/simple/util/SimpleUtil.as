package landray.kp.maps.simple.util
{
	import landray.kp.maps.simple.consts.SimpleConsts;
	import landray.kp.maps.simple.elements.BaseElement;
	import landray.kp.maps.simple.elements.Circle;
	import landray.kp.utils.CoreUtil;
	
	import model.vo.ElementVO;
	import model.vo.ShapeVO;
	
	public class SimpleUtil
	{
		public static function getElementVO(type:String):ElementVO
		{
			var path:String = SimpleConsts.SHAPE_UI_MAP.element.(@type == type).@voClassPath;
			var element:ElementVO = ElementVO(CoreUtil.getObjByClassPath(path));
			if (element == null) element = new ShapeVO;
			element.type = type;
			return element;
		}
		
		public static function getElementUI(vo:ElementVO):BaseElement
		{			
			var reference:Class = SimpleConsts.SHAPE_UI[vo.type];
			var element:BaseElement;
			element = (reference == null) ? new Circle(vo as ShapeVO) : new reference(vo);
			return element;
		}
	}
}