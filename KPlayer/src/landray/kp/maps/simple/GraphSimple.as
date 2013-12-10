package landray.kp.maps.simple
{
	import landray.kp.maps.simple.elements.BaseElement;
	import landray.kp.maps.simple.elements.Label;
	import landray.kp.maps.simple.util.SimpleUtil;
	import landray.kp.utils.CoreUtil;
	import landray.kp.view.Graph;
	
	import model.vo.ElementVO;
	
	
	
	public final class GraphSimple extends Graph
	{
		public function GraphSimple()
		{
			super();
			initialize();
		}
		
		private function initialize():void
		{
			mouseEnabled = false;
			elements = new Vector.<BaseElement>;
		}
		
		override public function render(scale:Number = 1):void
		{
			for each (var element:BaseElement in elements)
			{
				if (element is Label)
				{
					element.render(scale);
				}
			}
		}
		
		override public function set dataProvider(value:XML):void
		{
			//clear
			elements.length = 0;
			while(numChildren) removeChildAt(0);
			
			//create vos and elements
			var list:XMLList = value.children();
			for each (var xml:XML in list) {
				var vo:ElementVO = SimpleUtil.getElementVO(String(xml.@type));
				CoreUtil.mapping(xml, vo);
				var element:BaseElement = SimpleUtil.getElementUI(vo);
				addChild(element);
				elements.push(element);
			}
		}
		
		override public function set theme(value:String):void
		{
			super.theme = value;
			
			for each (var element:BaseElement in elements) {
				CoreUtil.applyStyle(element.vo);
				element.render();
			}
		}
		
		
		private var elements:Vector.<BaseElement>;
		
	}
}