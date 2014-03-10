package landray.kp.maps.main.util
{
	import landray.kp.core.KPConfig;
	import landray.kp.core.kp_internal;
	import landray.kp.maps.main.consts.MainConsts;
	import landray.kp.maps.main.elements.Circle;
	import landray.kp.maps.main.elements.Element;
	import landray.kp.utils.CoreUtil;
	
	import model.vo.ElementVO;
	import model.vo.ImgVO;
	import model.vo.ShapeVO;
	
	public class MainUtil
	{
		public static function getElementVO(type:String):ElementVO
		{
			var path:String = MainConsts.SHAPE_UI_MAP.element.(@type == type).@voClassPath;
			var element:ElementVO = ElementVO(CoreUtil.getObjByClassPath(path));
			if(!element) element = new ElementVO;
			element.type = type;
			return element;
		}
		
		public static function getElementUI(vo:ElementVO):Element
		{			
			var reference:Class = MainConsts.SHAPE_UI[vo.type];
			if (reference)
				var element:Element = new reference(vo);
			return  element;
		}
		
		public static function completeImgVO(vo:ImgVO):void
		{
			if (vo.url.indexOf("http:") != 0)
				vo.url = config.kp_internal::domain + vo.url;
		}
		
		private static var config:KPConfig = KPConfig.instance;
	}
}