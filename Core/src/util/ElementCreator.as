package util
{
	import com.kvs.utils.Map;
	
	import model.vo.ElementVO;
	import model.vo.ShapeVO;
	
	import view.element.ElementBase;
	import view.element.shapes.Circle;
	
	
	/**
	 * 负责图形创建
	 */	
	public class ElementCreator
	{
		/**
		 */		
		public function ElementCreator()
		{
		}
		
		/**
		 * 根据图形类型，获取VO， 默认为 ShapeVO
		 */		
		public static function getElementVO(type:String):ElementVO
		{
			var element:ElementVO = new (voMap.getValue(type) as Class) as ElementVO;
			
			if (element == null)
				element = new ShapeVO;
			
			element.id = ElementCreator.id;
			element.type = type;
			
			return element;
		}
		
		/**
		 * 根据图形类型获取UI，默认为Circle
		 */		
		public static function getElementUI(elementVO:ElementVO):ElementBase
		{
			var element:ElementBase = new (uiMap.getValue(elementVO.type) as Class)(elementVO) as ElementBase;
			
			if (element == null)
				element = new Circle(elementVO as ShapeVO);
			
			return element;
		}
		
		/**
		 */		
		public static function registerElement(type:String, uiClass:Class, voClass:Class):void
		{
			uiMap.put(type, uiClass);
			voMap.put(type, voClass);
		}
		
		/**
		 */		
		private static var voMap:Map = new Map;
		
		/**
		 */		
		private static var uiMap:Map = new Map;
		
		/**
		 */		
		private static const SHAPE_UI_MAP:XML = <elements>
													<element type="circle" uiClassPath="view.element.shapes.Circle" voClassPath="model.vo.ShapeVO"/>
													<element type="rect" uiClassPath="view.element.shapes.Rect" voClassPath="model.vo.ShapeVO"/>
													<element type="arrow" uiClassPath="view.element.shapes.Arrow" voClassPath="model.vo.ArrowVO"/>
													<element type="doubleArrow" uiClassPath="view.element.shapes.DoubleArrow" voClassPath="model.vo.ArrowVO"/>
													<element type="triangle" uiClassPath="view.element.shapes.Triangle" voClassPath="model.vo.ShapeVO"/>
													<element type="stepTriangle" uiClassPath="view.element.shapes.StepTriangle" voClassPath="model.vo.ShapeVO"/>
													<element type="diamond" uiClassPath="view.element.shapes.Diamond" voClassPath="model.vo.ShapeVO"/>
													<element type="star" uiClassPath="view.element.shapes.Star" voClassPath="model.vo.StarVO"/>
			
													<element type="line" uiClassPath="view.element.shapes.LineElement" voClassPath="model.vo.LineVO"/>
													<element type="arrowLine" uiClassPath="view.element.shapes.ArrowLine" voClassPath="model.vo.LineVO"/>
													<element type="doubleArrowLine" uiClassPath="view.element.shapes.DoubleArrowLine" voClassPath="model.vo.LineVO"/>
			
													<element type="text" uiClassPath="view.element.text.TextEditField" voClassPath="model.vo.TextVO"/>
													<element type="img" uiClassPath="view.element.imgElement.ImgElement" voClassPath="model.vo.ImgVO"/>
													<element type="hotspot" uiClassPath="view.element.shapes.HotspotElement" voClassPath="model.vo.HotspotVO"/>
													<element type="group" uiClassPath="view.element.GroupElement" voClassPath="model.vo.GroupVO"/>
													<element type="dashRect" uiClassPath="view.element.shapes.DashRect" voClassPath="model.vo.ShapeVO"/>
												</elements>
			
		/**
		 * 全局的元素ID都从这里分配
		 */		
		public static function get id():uint
		{
			return _shapeID ++;
		}
		
		/**
		 */		
		public static function setID(value:uint):void
		{
			if (value > _shapeID)
				_shapeID = value;
		}
		
		/**
		 */		
		private static var _shapeID:uint = 1;
		
		
	}
}